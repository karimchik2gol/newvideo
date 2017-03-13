class YoutubeTrendsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 3, :dead => false

  def perform(params, user_id)
    Video.parse_trends(params, user_id)
  end
end
