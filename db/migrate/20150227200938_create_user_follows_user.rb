class CreateUserFollowsUser < ActiveRecord::Migration
  def change
    create_table :user_followers do |t|
      t.integer :user_id, null: false    # user who clicked "follow"
      t.integer :target_id, null: false  # person being followed
      t.timestamps null: false
    end
  end
end
