class CreateSectionNotes < ActiveRecord::Migration
  def change
    create_table :section_notes do |t|
      
      t.integer :canvas_section_id
      t.string :identifier, limit: 4, null: false
      t.string :status
      t.text :text

      t.timestamps null: false
      add_foreign_key :section_notes, :canvas_sections, { :column => :canvas_section_id, :on_delete => :cascade } #or :nullify
    end
  end
end
