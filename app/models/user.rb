class User < ActiveRecord::Base
    has_many :tweets
    has_many :users, :through => :follow_relationships
end