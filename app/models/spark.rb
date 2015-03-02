class Spark < ActiveRecord::Base
  
  validates :name,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }
  
  validates_presence_of :summary, :description
  
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id' 
  
  def ownerless?
    return self.owner_id.nil? || self.owner.nil?
  end
  
  # Name shown in the activity partial
  # Also a safe name to show in general
  def activity_name
    return self.name
  end
  
  if Rails.application.config.feature_map.enabled?(:activity)
    def activities
      to_return = Activity.where('(source_type = "spark" AND source_id = :id) OR (target_type = "spark" AND target_id = :id)', { :id => self.id })
        .order(:created_at => :desc)
      return to_return
    end
  end
  
  if Rails.application.config.feature_map.enabled?(:spark_likes)
    has_many :likes
  end
end
