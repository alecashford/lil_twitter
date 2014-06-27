class UpdateTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :author_id, :integer
  end
end
