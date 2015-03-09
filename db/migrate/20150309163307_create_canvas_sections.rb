class CreateCanvasSections < ActiveRecord::Migration
  def change
    create_table :canvas_sections do |t|
      
      t.integer :spark_id
      t.string :name
      t.integer :x
      t.integer :y
      t.integer :width
      t.integer :height

      t.timestamps null: false
      add_foreign_key :canvas_sections, :sparks, { :column => :spark_id, :on_delete => :cascade } #or :nullify
    end
  end
end
