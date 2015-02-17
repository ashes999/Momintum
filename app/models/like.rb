if Rails.application.config.feature_map.enabled?(:like_sparks)
  class Like < ActiveRecord::Base
    belongs_to :user
    belongs_to :spark
  
    validates_presence_of :user, :spark
  end
end