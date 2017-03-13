class User < ActiveRecord::Base
    has_secure_password

    has_many :videos, dependent: :destroy
    has_one :my_category, dependent: :destroy

    def is_super_admin?
        self.super_admin
    end
    
end
