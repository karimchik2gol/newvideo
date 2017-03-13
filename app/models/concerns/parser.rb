#coding:UTF-8
require 'open-uri'
require 'nokogiri'

module Parser
	extend ActiveSupport::Concern
	$allowed_videos = ["день", "дні", "годин", "хвил", "сек"]
	$base_url = "https://www.youtube.com"

	def parse
		remove_video
		get_videos
	end

	private
	def remove_video
		Video.delete_all
	end

	def get_videos
		Channel.all.each do |f|
			link = f.link + "/videos"
			html = open(link)
			doc = Nokogiri::HTML(html, nil, 'UTF-8')
			get_and_add_video(doc, f)

		end
	end

	def get_and_add_video(doc, channel)
		doc.css(".channels-content-item").each do |f|
			if f.css(".yt-lockup-meta-info li")[1]
				date = f.css(".yt-lockup-meta-info li")[1].text
				if $allowed_videos.include?(date.split(" ")[1])
					anchor = f.css(".yt-lockup-content a")[0]
					title = anchor.text
					href = $base_url + anchor['href']
					views = f.css(".yt-lockup-meta-info li")[0].text.gsub(/\D/, "").to_i
					opts = {:title => title, :href => href, :views => views}
					channel.videos.build(opts).save
					return true
				end
			end
		end
	end
end