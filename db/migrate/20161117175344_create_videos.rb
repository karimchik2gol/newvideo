class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :channel_id
      t.string :title
      t.string :href
      t.integer :views

      t.timestamps null: false
    end
  end
end
