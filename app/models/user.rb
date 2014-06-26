class User < ActiveRecord::Base
    has_many :tweets
    has_many :follow_relationships
    has_many :followed_users, :through => :follow_relationships
end

