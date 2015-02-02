class CreateSparks < ActiveRecord::Migration
  def change
    create_table :sparks do |t|
      t.string :name, null: false, unique: true
      t.string :summary, null: false
      t.text :description, null: false
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
