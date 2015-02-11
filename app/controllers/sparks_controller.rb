class SparksController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show, :index]
  
  attr_accessor :sparks # for controller functional testing
  
  def new
    @spark = Spark.new
  end

  def create
    fields = params[:spark]
    
    @spark = Spark.new(:name => fields[:name], :summary => fields[:summary], 
      :description => fields[:description], :owner_id => fields[:owner_id].to_i)
      
    if @spark.valid?
      @spark.save
      redirect_to @spark
    else
      render :action => 'new'
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

  def update
  end

  def destroy
  end
end
