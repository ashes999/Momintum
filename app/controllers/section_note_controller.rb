if Rails.application.config.feature_map.enabled?(:ideation)
  class SectionNoteController < ApplicationController
    before_filter :authenticate_user!

    def create
      spark_id = params[:spark_id] 
      section_id = params[:section_id]
      identifier = params[:identifier]
      
      canvas_section = CanvasSection.find_by_id(section_id)
      if identifier.nil?
        message = 'Please specify an identifier.'
      elsif Spark.find_by_id(spark_id).nil?
        message = 'This spark doesn\'t exist any more.'
      elsif canvas_section.nil?
        message = 'That section doesn\'t exist any more.'
      elsif current_user.nil? || !current_user.can_edit?(canvas_section.spark)
        message = 'You don\'t have permission to ideate this spark.'
      else
        note = SectionNote.new(:canvas_section_id => section_id, :identifier => identifier, :status => :undecided, :text => params[:text])
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

    def update
      note_id = params[:id] 
      note = SectionNote.find_by_id(note_id)
      
      if note.nil?
        message = 'That note doesn\'t exist.'
      elsif current_user.nil? || !current_user.can_edit?(note.canvas_section.spark)
        message = 'You don\'t have permission to ideate this spark.'
      else
        # not required to be specified/updated
        note.identifier = params[:identifier] unless params[:identifier].nil?
        note.text = params[:text] unless params[:text].nil?
        note.status = params[:status] unless params[:status].nil?
        if note.identifier.length > 4
          message = "Please enter a 1-4 character identifier."
        else
          note.save
          result = note
        end
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