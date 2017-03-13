class CategoryJob < ActiveJob::Base
  queue_as :default

  def perform
  end
end
