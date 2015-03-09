class CanvasSectionsController < ApplicationController
  before_action :set_canvas_section, only: [:show, :edit, :update, :destroy]

  # GET /canvas_sections
  # GET /canvas_sections.json
  def index
    @canvas_sections = CanvasSection.all
  end

  # GET /canvas_sections/1
  # GET /canvas_sections/1.json
  def show
  end

  # GET /canvas_sections/new
  def new
    @canvas_section = CanvasSection.new
  end

  # GET /canvas_sections/1/edit
  def edit
  end

  # POST /canvas_sections
  # POST /canvas_sections.json
  def create
    @canvas_section = CanvasSection.new(canvas_section_params)

    respond_to do |format|
      if @canvas_section.save
        format.html { redirect_to @canvas_section, notice: 'Canvas section was successfully created.' }
        format.json { render :show, status: :created, location: @canvas_section }
      else
        format.html { render :new }
        format.json { render json: @canvas_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /canvas_sections/1
  # PATCH/PUT /canvas_sections/1.json
  def update
    respond_to do |format|
      if @canvas_section.update(canvas_section_params)
        format.html { redirect_to @canvas_section, notice: 'Canvas section was successfully updated.' }
        format.json { render :show, status: :ok, location: @canvas_section }
      else
        format.html { render :edit }
        format.json { render json: @canvas_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /canvas_sections/1
  # DELETE /canvas_sections/1.json
  def destroy
    @canvas_section.destroy
    respond_to do |format|
      format.html { redirect_to canvas_sections_url, notice: 'Canvas section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_canvas_section
      @canvas_section = CanvasSection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def canvas_section_params
      params.require(:canvas_section).permit(:spark_id, :name, :x, :y, :width, :height)
    end
end
