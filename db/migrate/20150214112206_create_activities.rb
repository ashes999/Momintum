class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :key # see activity model
      # used for finding activities by user/idea
      t.integer :source_id, null: false
      t.string :source_type, null: false
      t.integer :target_id, null: false
      t.string :target_type, null: false
      t.timestamps null: false
    end
  end
end
