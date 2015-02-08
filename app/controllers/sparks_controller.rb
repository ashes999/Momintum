class SparksController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show, :index]
  
  def new
    @spark = Spark.new
  end

  def create
    @spark.save
  end
  
  def index
    @sparks = Spark.all
  end
  
  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
