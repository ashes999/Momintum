class SparksController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show, :index]
  
  attr_accessor :sparks # for controller functional testing
  
  def new
    @spark = Spark.new
  end

  def create
    @spark = Spark.new
    if (create_or_update() == true)
      Activity.create(:key => :created_spark, :source_id => current_user.id, :source_type => :user,
        :target_id => @spark.id, :target_type => :spark)
    end
  end
  
  def update
    @spark = Spark.find(params[:id])
    if (create_or_update() == true)
      Activity.create(:key => :updated_spark, :source_id => current_user.id, :source_type => :user,
        :target_id => @spark.id, :target_type => :spark)
    end
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
      return true
    else
      render :action => 'edit'
      return false
    end
  end
end
