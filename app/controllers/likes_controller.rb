if Rails.application.config.feature_map.enabled?(:like_sparks)
  class LikesController < ApplicationController
    before_filter :authenticate_user!
    
    def like
      user_id = params[:user_id]
      spark_id = params[:spark_id]
      raise 'Missing user id' if user_id.nil?
      raise 'Missing spark id' if spark_id.nil?
      
      Like.create(:user_id => user_id, :spark_id => spark_id)
      Activity.create(:key => :likes_spark, :source_type => :user, :source_id => user_id, 
        :target_type => :spark, :target_id => spark_id)
        
      redirect_to Spark.find(spark_id)
    end
    
    def dislike
      raise 'Missing user id' if params[:user_id].nil?
      raise 'Missing spark id' if params[:spark_id].nil?
      l = Like.find_by(:user_id => params[:user_id], :spark_id => params[:spark_id])
      l.destroy unless l.nil?
      
      redirect_to Spark.find(params[:spark_id])
    end
  end
end