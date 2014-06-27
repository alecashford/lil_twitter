class CreateTables < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :first_name
      t.string :last_name
      t.string :salt
      t.timestamps
    end
    create_table :tweets do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    create_table :follow_relationships do |t|
      t.integer :user_id
      t.integer :followed_user_id

      t.timestamps
    end
  end
end