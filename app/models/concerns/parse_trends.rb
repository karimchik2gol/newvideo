require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
require 'open-uri'
require 'nokogiri'
require 'open-uri'
require 'launchy'
require 'socket'

class YoutubeVideo
  # Set DEVELOPER_KEY to the API key value from the APIs & auth > Credentials
  # tab of
  # {{ Google Cloud Console }} <{{ https://cloud.google.com/console }}>
  # Please ensure that you have enabled the YouTube Data API for your project.
  YOUTUBE_UPLOAD_SCOPE = ['https://www.googleapis.com/auth/youtube',
                        'https://www.googleapis.com/auth/youtube.force-ssl',
                        'https://www.googleapis.com/auth/youtube.readonly',
                        'https://www.googleapis.com/auth/youtubepartner',
                        'https://www.googleapis.com/auth/youtubepartner-channel-audit'
                        ]
  # Initial constants
  DEVELOPER_KEY = ENV["DEVELOPER_KEY"]
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  attr_accessor :application_name, :application_version, :client, :youtube, :redirect_url, :client, :channel_subs,
                :file_storage, :client_secrets, :opts, :flow, :auth, :minimum_views_count, :parameters, :user

  def initialize(application_name, application_version, redirect_url, max_results, days_after_publishing, minimum_views_count, channel_subs)
    self.application_name = application_name
    self.application_version = application_version
    self.redirect_url = redirect_url
    self.minimum_views_count = minimum_views_count
    self.channel_subs = channel_subs

    # Search parameters
    self.parameters = {  :part => 'id,snippet',
      :order => 'viewCount',
      :publishedAfter => published_after(days_after_publishing),
      :type => 'video',
      :maxResults => max_results 
  }
  end


  # initiaalize youtube api
  def init_api
    self.client = Google::APIClient.new(:application_name => self.application_name, :application_version => self.application_version)
    self.youtube = self.client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
    self.file_storage = Google::APIClient::FileStorage.new("#{$PROGRAM_NAME}-oauth2.json")

    self.client_secrets = Google::APIClient::ClientSecrets.load
    self.opts = {
      :client_id => self.client_secrets.client_id,
      :client_secret => self.client_secrets.client_secret,
      :scope => YOUTUBE_UPLOAD_SCOPE
    }

    self.flow = Google::APIClient::InstalledAppFlow.new(self.opts)
  end

  def authorize
    self.client.authorization = flow.authorize(file_storage)
    update_signetoauth
  end

  def delete_user_videos(user_id)
    self.user = User.find(user_id)
    # Destroy previous video
    self.user.videos.where("created_at < ?", Time.now - 1.day).destroy_all
  end

  def determine_request_type(search)
    # Check if query
    # Check specific categoriees?
    # Else all categories
    if search["search"] && !search["search"]["q"].empty?
      search["search"]["q"].split("|").each do |term|
        self.parameters.delete(:pageToken)
        self.parameters[:q] = term
      end
    elsif search["category_ids"]
      search["category_ids"].each do |f|
        parameters.delete(:pageToken)
        parameters[:videoCategoryId] = f.to_i
      end
    end
  end

  def send_query_to_api
    # Send request to server
    search_response = self.client.execute!(
        :api_method => self.youtube.search.list,
        :parameters => self.parameters
    )

    # Add each result to the appropriate list, and then display the lists of
    # matching videos, channels, and playlists.
    self.parameters[:pageToken] = search_response.data.nextPageToken if search_response.data.as_json["nextPageToken"]

    search_response.data.items.each do |search_result|
      result = search_result.as_json
      snippet = search_result.snippet.as_json

      # Get views with Nokogiri
      views_number, url = get_views_number(result)
    
      # Check if we should add video to popular
      # If ok, continue adding and then start parsing next page with recurrence.
      # Else return false
      i = 0
      if views_number >= self.minimum_views_count && channel_has_low_subs_then_determined(search_result['snippet']['channelId'])
        video_params = { views: views_number, title: snippet["title"], thumbnail: snippet["thumbnails"]["medium"]["url"], href: url }
        if Video.where(thumbnail: video_params[:thumbnail]).count == 0
          video = self.user.videos.build(video_params)
          video.category_id = self.parameters[:videoCategoryId] if self.parameters[:videoCategoryId]
          video.save
        end

        i += 1
        puts "Brilliant! I've added #{i} videos already!"
      elsif views_number < self.minimum_views_count
        return false
      end
    end

    # Recurrence call for next page
    send_query_to_api
  end

  private
  def update_signetoauth
    self.auth = Signet::OAuth2::Client.new({
      :authorization_uri => 'https://accounts.google.com/o/oauth2/auth',
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :redirect_uri => self.redirect_url}.update(opts)
    )
  end

  def published_after(days)
    ddays = days <= 1 ? 1.day : days.days
    return (Time.now - ddays).to_datetime.rfc3339
  end

  def get_views_number(result)
    views = 0
    id = result["id"]["videoId"]
    url = "https://www.youtube.com/watch?v=" + id
    html = open(url)
    doc = Nokogiri::HTML(html, nil, 'UTF-8')
    # 3 attempts to get views
    3.times do
      views = doc.css(".watch-view-count").text.gsub(" ", "").to_i
      if views > 0
        break 
      else
        sleep 1
      end
    end

    return views, url
  end

  def channel_has_low_subs_then_determined(channel_id)
    search_response = self.client.execute!(
      :api_method => self.youtube.channels.list,
      :parameters => { part: 'snippet,statistics', id: channel_id }
    )

    subs = search_response.data.items[0].as_json['statistics']['subscriberCount'].to_i

    return subs != 0 && subs <= self.channel_subs
  end
end


module ParseTrends
  extend ActiveSupport::Concern

  def parse_trends(search, user_id)
    # initial settings
    # parameters: application_name, application_version, redirect_url, max_results, day_after_publishing, minimum_views_count, channel_subs
    yv = YoutubeVideo.new('test', '1.0.0', 'http://localhost:3000/success', 50, 180, 2 * (10 ** 6), 15 * (10 ** 4))
    yv.init_api
    yv.authorize

    # # destroy previous videos
    yv.delete_user_videos(user_id) 

    # determine request type: category or query
    yv.determine_request_type(search)
    yv.send_query_to_api
  end      
end