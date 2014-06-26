class FollowedUser < ActiveRecord::Base
  has_many :follow_relationships
end