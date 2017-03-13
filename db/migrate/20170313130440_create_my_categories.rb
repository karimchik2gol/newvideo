class CreateMyCategories < ActiveRecord::Migration
  def change
    create_table :my_categories do |t|
      t.string :list_categories
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
