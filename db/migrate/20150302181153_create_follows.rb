class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :follower_id, null: false # User who clicked "follow"
      t.integer :target_id, null: false   # User being followed
      t.timestamps null: false
    end
  end
end
