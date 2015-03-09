class CreateTeams < ActiveRecord::Migration
  def change
    create_table :sparks_users do |t|
      t.integer :user_id
      t.integer :spark_id
    end
  end
end
