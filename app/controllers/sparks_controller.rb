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
    
    operation = fields[:id].nil? ? :create : :edit
    # Don't update owner on edit
    @spark.owner_id = fields[:owner_id].to_i unless fields[:owner_id].nil?
    
    if @spark.valid?
      @spark.save
      
      if Rails.application.config.feature_map.enabled?(:user_follows)
        if operation == :create
          subject = "New Spark: #{@spark.name}"
          url = url_for :controller => 'sparks', :action => 'show', :id => @spark.id
          owner_name = User.find(@spark.owner_id).username
          body = "#{User.find(@spark.owner_id).username} created a new spark called '#{@spark.name}' on Momintum. You can view the details here: #{url}"
          #puts "Email: #{subject}\n#{body}"
        elsif operation == :update
          if Spark.find(fields[:id]).description != @spark.description
            subject = "Updated Spark: #{@spark.name}"
            url = url_for :controller => 'sparks', :action => 'show', :id => @spark.id
            body = "#{User.find(@spark.owner_id).username} updated the spark called '#{@spark.name}' on Momintum. You can view the details here: #{url}"
            #puts "Email: #{subject}\n#{body}"
          end
        end
      end
      
      redirect_to @spark
      return true
    else
      render :action => 'edit'
      return false
    end
  end
end
