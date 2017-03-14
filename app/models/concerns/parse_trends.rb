# require 'google/api_client'
# require 'google/api_client/client_secrets'
# require 'google/api_client/auth/file_storage'
# require 'google/api_client/auth/installed_app'
# require 'open-uri'
# require 'nokogiri'

module ParseTrends
	extend ActiveSupport::Concern
    # # Set DEVELOPER_KEY to the API key value from the APIs & auth > Credentials
    # # tab of
    # # {{ Google Cloud Console }} <{{ https://cloud.google.com/console }}>
    # # Please ensure that you have enabled the YouTube Data API for your project.
    # YOUTUBE_UPLOAD_SCOPE = ['https://www.googleapis.com/auth/youtube',
    #                         'https://www.googleapis.com/auth/youtube.force-ssl',
    #                         'https://www.googleapis.com/auth/youtube.readonly',
    #                         'https://www.googleapis.com/auth/youtubepartner'
    #                     ]

    # DEVELOPER_KEY = ENV["DEVELOPER_KEY"]
    # YOUTUBE_API_SERVICE_NAME = 'youtube'
    # YOUTUBE_API_VERSION = 'v3'

    # def get_service
    #     client = Google::APIClient.new(
    #         :application_name => 'Test',
    #         :application_version => '1.0.0'
    #     )
    #     youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
    #     file_storage = Google::APIClient::FileStorage.new("#{$PROGRAM_NAME}-oauth2.json")

    #     client_secrets = Google::APIClient::ClientSecrets.load
    #     flow = Google::APIClient::InstalledAppFlow.new(
    #         :client_id => client_secrets.client_id,
    #         :client_secret => client_secrets.client_secret,
    #         :scope => YOUTUBE_UPLOAD_SCOPE
    #     )
    #     client.authorization = flow.authorize(file_storage)

    #     return client, youtube
    # end

    def parse_trends(search, user_id)
    #     client, youtube = get_service
    #     user = User.find(user_id)

    #     # Destroy previous video
    #     user.videos.where("created_at < ?", Time.now - 1.day).destroy_all

    #     # Generate search parameters
    #     parameters = {  :part => 'id,snippet',
    #                     :order => 'viewCount',
    #                     :publishedAfter => '2017-03-12T01:41:06+02:00',#(Time.now - 1.day).to_datetime.rfc3339,
    #                     :type => 'video',
    #                     :maxResults => 50 }

    #     # Check if params :q
    #     # Check if params :category_ids is not empty?
    #     # Else for each category send request
    #     if search["search"] && !search["search"]["q"].empty?
    #         search["search"]["q"].split("|").each do |term|
    #             parameters.delete(:pageToken)
    #             parameters[:q] = term
    #             send_query_to_api(client, youtube, parameters, user)
    #         end
    #     elsif search["category_ids"]
    #         puts search["category_ids"]
    #         search["category_ids"].each do |f|
    #             puts "Category: #{f}"
    #             parameters.delete(:pageToken)
    #             parameters[:videoCategoryId] = f.to_i
    #             puts "Parameters: #{parameters}"
    #             send_query_to_api(client, youtube, parameters, user)
    #         end
    #     else
    #         send_query_to_api(client, youtube, parameters, user)
    #     end
    end

    # def send_query_to_api(client, youtube, parameters, user)
    #     # Send request to server
    #     search_response = client.execute!(
    #         :api_method => youtube.search.list,
    #         :parameters => parameters
    #     )

    #     # Add each result to the appropriate list, and then display the lists of
    #     # matching videos, channels, and playlists.
    #     parameters[:pageToken] = search_response.data.nextPageToken if search_response.data.as_json["nextPageToken"]
    #     search_response.data.items.each do |search_result|
    #         result = search_result.as_json
    #         snippet = search_result.snippet.as_json

    #         # Get views with Nokogiri
    #         views_number, url = get_views_number(result)
            
    #         # Check if we should add video to popular
    #         # If ok, continue adding and then start parsing next page with recurrence.
    #         # Else return false
    #         puts views_number
    #         if views_number > 200000
    #             params= { views: views_number, title: snippet["title"], thumbnail: snippet["thumbnails"]["medium"]["url"], href: url }
    #             if Video.where(thumbnail: params[:thumbnail]).count == 0
    #                 video = user.videos.build(params)
    #                 video.category_id = parameters[:videoCategoryId] if parameters[:videoCategoryId]
    #                 video.save
    #             end
    #         # Check if video isn't stream
    #         elsif views_number != 0 and views_number < 150000
    #             return
    #         end
    #     end

    #     # Recurrence call for next page
    #     send_query_to_api(client, youtube, parameters, user)
    # end

    # def get_views_number(result)
    #     views = 0
    #     id = result["id"]["videoId"]
    #     url = "https://www.youtube.com/watch?v=" + id
    #     html = open(url)
    #     doc = Nokogiri::HTML(html, nil, 'UTF-8')
    #     # 3 attempts to get views
    #     3.times do
    #         views = doc.css(".watch-view-count").text.gsub(" ", "").to_i
    #         if views > 0
    #             break 
    #         else
    #             sleep 1
    #         end
    #     end

    #    # puts views

    #     return views, url
    # end
    
end