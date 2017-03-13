class MyCategory < ActiveRecord::Base
    belongs_to :user
    
    def set_new_categories(categories)
        if categories
            update_attributes(list_categories: categories.join(","))
        end
    end
    
end
