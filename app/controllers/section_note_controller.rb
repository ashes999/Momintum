class SectionNoteController < ApplicationController
  def update
  end

  def destroy
    note_id = params[:id] 
    
    message = 'Please specify the note' if note_id.nil?
    note = SectionNote.find(note_id)
    
    if current_user.nil? || !current_user.can_edit?(note.canvas_section.spark)
      message = 'You don\'t have permission to ideate this spark.'
    else
      note.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to note.nil? ? root_url : note.canvas_section.spark }
      format.json { render json: { success: true, message: message } }
      format.js
    end
  end
end
