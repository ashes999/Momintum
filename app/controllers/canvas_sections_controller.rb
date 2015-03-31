if Rails.application.config.feature_map.enabled?(:ideation)
  class CanvasSectionsController < ApplicationController
    before_filter :authenticate_user!
    
    def create
      spark = Spark.find(params[:spark_id])
      if current_user.nil? || !current_user.can_edit?(spark)
        message = 'You don\'t have permission to ideate this spark.' 
      else
        # Place under the rest of the canvases
        lowest_canvas = spark.canvas_sections.order("y + height DESC").first
        
        if lowest_canvas.nil? || lowest_canvas.y.nil? || lowest_canvas.height.nil?
          max_y = 0
        else
          max_y = lowest_canvas.y + lowest_canvas.height
        end
        
        section = CanvasSection.new(:spark_id => spark.id, :y => max_y)
      end
      
      if !section.nil? && section.valid?
        section.save
        result = section
      else
        message = 'Couldn\'t create canvas section.'
        result = { :message => message }
      end
      
      respond_to do |format|
        format.html { redirect_to section.nil? ? root_url : section.spark }
        format.json { render json: result }
        format.js
      end
    end
    
    def update
      sectionId = params[:sectionId] # eg. "section12"
      sectionId = sectionIdToId(sectionId)
      message = 'Please specify the section' if sectionId.nil?
      section = CanvasSection.find(sectionId)
      
      if current_user.nil? || !current_user.can_edit?(section.spark)
        message = 'You don\'t have permission to ideate this spark.'
      else
      
        x = params[:x]
        y = params[:y]
        width = params[:width]
        height = params[:height]
        
        section.x = x unless x.nil?
        section.y = y unless y.nil?
        section.width = width unless width.nil?
        section.height =  height unless height.nil?
        
        if section.valid?
          section.save
          result = section
        else
          message = 'Couldn\'t save canvas section.'
        end
      end
      
      result = { :error => message } if !message.nil?
      
      respond_to do |format|
        format.html { redirect_to section.nil? ? root_url : section.spark }
        format.json { render json: result }
        format.js
      end
    end
    
    def destroy
      sectionId = params[:sectionId] # eg. "section12"
      sectionId = sectionIdToId(sectionId)
      message = 'Please specify the section' if sectionId.nil?
      section = CanvasSection.find(sectionId)
      
      if current_user.nil? || !current_user.can_edit?(section.spark)
        message = 'You don\'t have permission to ideate this spark.'
      else
        section.destroy
      end
      
      respond_to do |format|
        format.html { redirect_to section.nil? ? root_url : section.spark }
        format.json { render json: { success: true, message: message } }
        format.js
      end
    end
    
    private
    
    def sectionIdToId(sectionId)
      return nil if sectionId.nil?
      return sectionId[sectionId.index('section') + 'section'.length, sectionId.length].strip
    end
  end
end