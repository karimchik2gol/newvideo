class CategoryIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :category_id, :integer
  end
end
