class CreateUserLikesSpark < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id, null: false
      t.integer :spark_id, null: false
      t.timestamps null: false
    end
  end
end
