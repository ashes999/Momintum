class SparksController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show, :index]
  
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
  end

  def update
  end

  def destroy
  end
end
