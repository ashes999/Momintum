if Rails.application.config.feature_map.enabled?(:ideation)
  class CanvasSectionsController < ApplicationController
    before_filter :authenticate_user!
    
    def create
      # TODO: verify current user has edit permissions
      
      spark = Spark.find(params[:spark_id])
      # Place under the rest
      lowest_canvas = spark.canvas_sections.order("y + height DESC").first
      
      if lowest_canvas.nil?
        max_y = 0
      else
        max_y = lowest_canvas.y + lowest_canvas.height
      end
      
      section = CanvasSection.new({:spark_id => spark.id, :name => 'New Section', :x => 0, :y => max_y, :width => 300, :height => 150})
      
      if section.valid?
        section.save
        result = section
      else
        message = 'Couldn\'t create canvas section.'
        result = { :message => message }
      end
      
      respond_to do |format|
        format.html { puts "HTML"; redirect_to spark }
        format.json { puts "JSON"; render json: result }
        format.js
      end
    end
    
    def update
      # TODO: verify current user has edit permissions
      
      sectionId = params[:sectionId] # eg. "section12"
      sectionId = sectionIdToId(sectionId)
      
      x = params[:x]
      y = params[:y]
      message = 'Please specify the section' if sectionId.nil?
      message = 'Please specify the x position' if x.nil?
      message = 'Please specify the y position' if y.nil?
      
      if message.nil?
        section = CanvasSection.find(sectionId)
        section.x = x
        section.y = y
        
        if section.valid?
          section.save
          result = section
        else
          message = 'Couldn\'t save canvas section.'
        end
      end
      
      result = { :error => message } if !message.nil?
      
      respond_to do |format|
        format.html { puts "HTML"; redirect_to section.spark }
        format.json { puts "JSON"; render json: result }
        format.js
      end
    end
    
    def destroy
      puts "@@@ INSIDE, params are #{params}"
      # TODO: verify current user has edit permissions
      sectionId = params[:sectionId] # eg. "section12"
      sectionId = sectionIdToId(sectionId)
      message = 'Please specify the section' if sectionId.nil?
      section = CanvasSection.find(sectionId)
      section.destroy
      
      respond_to do |format|
        format.html { puts "HTML"; redirect_to section.spark }
        format.json { puts "JSON"; render json: { success: true, message: message } }
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