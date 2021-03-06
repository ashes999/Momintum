class CreateSparks < ActiveRecord::Migration
  def change
    create_table :sparks do |t|
      t.string :name, null: false, unique: true
      t.string :summary, null: false
      t.text :description, null: false
      # null is for orphaned sparks
      t.integer :owner_id, null: true, indexed: true
      t.timestamps null: false
    end
    
    add_foreign_key :sparks, :users, { :column => :owner_id, :on_delete => :cascade } #or :nullify
  end
end
