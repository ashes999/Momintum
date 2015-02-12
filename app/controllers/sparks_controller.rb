class SparksController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show, :index]
  
  attr_accessor :sparks # for controller functional testing
  
  def new
    @spark = Spark.new
  end

  def create
    @spark = Spark.new
    create_or_update()
  end
  
  def update
    @spark = Spark.find(params[:id])
    create_or_update()
  end
  
  def index
    @sparks = Spark.all
  end
  
  def show
    @spark = Spark.find(params[:id])
  end

  def edit
    @spark = Spark.find_by_id(params[:id])
    if @spark.nil?
      flash[:alert] = 'This spark seems to be gone.'
      #redirect_to(:back)
    elsif !current_user.can_edit?(@spark)
      flash[:alert] = 'You don\'t have permission to edit this spark.'
      #redirect_to(:back)
    end
  end
  
  def destroy
  end
  
  private
  
  def create_or_update
    fields = params[:spark]
    
    @spark.name = fields[:name]
    @spark.summary = fields[:summary]
    @spark.description = fields[:description]
    # Don't update owner on edit
    @spark.owner_id = fields[:owner_id].to_i if fields[:id].nil?
      
    if @spark.valid?
      @spark.save
      redirect_to @spark
    else
      render :action => 'edit'
    end
  end
end
