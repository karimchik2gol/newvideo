class CategoryJob < ActiveJob::Base
  queue_as :default

  def perform
    Category.parse_categories
  end
end
