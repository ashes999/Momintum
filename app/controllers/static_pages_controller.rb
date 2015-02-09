class StaticPagesController < ApplicationController
  def home
    @sparks = Spark.all.order(:created_at => :desc)
  end
 
  def contact
  end
  
  def updates
  end
end
