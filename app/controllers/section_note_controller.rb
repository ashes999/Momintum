if Rails.application.config.feature_map.enabled?(:ideation)
  class SectionNoteController < ApplicationController
    before_filter :authenticate_user!

    def update
      note_id = params[:id] 
      note = SectionNote.find_by_id(note_id)
      if note.nil?
        message = 'That note doesn\'t exist.'
      elsif current_user.nil? || !current_user.can_edit?(note.canvas_section.spark)
        message = 'You don\'t have permission to ideate this spark.'
      else
        note.text = params[:text]
        note.status = params[:status]
        note.save
        result = note
      end
      
      result = { :message => message } if result.nil?
      
      respond_to do |format|
        format.html { redirect_to note.nil? ? root_url : note.canvas_section.spark }
        format.json { render json: result }
        format.js
      end
    end
  
    def destroy
      note_id = params[:id] 
      note = SectionNote.find_by_id(note_id)
      if note.nil?
        message = 'That note doesn\'t exist.'
      elsif current_user.nil? || !current_user.can_edit?(note.canvas_section.spark)
        message = 'You don\'t have permission to ideate this spark.'
      else
        note.destroy
        result = note
      end
    
      result = { :message => message } if result.nil?
      
      respond_to do |format|
        format.html { redirect_to note.nil? ? root_url : note.canvas_section.spark }
        format.json { render json: result }
        format.js
      end
    end
  end
end