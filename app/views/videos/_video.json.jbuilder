json.extract! video, :id, :channel_id, :title, :href, :views, :created_at, :updated_at
json.url video_url(video, format: :json)