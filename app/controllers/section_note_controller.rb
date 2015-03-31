if Rails.application.config.feature_map.enabled?(:ideation)
  class SectionNoteController < ApplicationController
    before_filter :authenticate_user!

    def update
    end
  
    def destroy
      note_id = params[:id] 
      
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
end