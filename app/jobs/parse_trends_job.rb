class ParseTrendsJob < ActiveJob::Base
  queue_as :default

  def perform(params, user_id)
    Video.parse_trends(params, user_id)
  end
end
