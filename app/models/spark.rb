class Spark < ActiveRecord::Base
  
  validates :name,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }
  
  validates_presence_of :summary, :description
  
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id' 
  
  if Rails.application.config.feature_map.enabled?(:activity)
    has_many :canvas_sections
  end
  
  if Rails.application.config.feature_map.enabled?(:spark_teams)
    has_and_belongs_to_many :team_members, :class_name => 'User', :join_table => :sparks_users
  end
  
  def ownerless?
    return self.owner_id.nil? || self.owner.nil?
  end
  
  # Name shown in the activity 
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
  
  def interested_parties
    to_return = []
    
    # Include people who like the idea
    if Rails.application.config.feature_map.enabled?(:spark_likes)
      self.likes.each do |l|
        to_return << l.user.email
      end
    end
    
    # Include people who are following the owner
    if Rails.application.config.feature_map.enabled?(:follow_users)
      User.find(self.owner_id).follows.each do |f|
        to_return << f.user.email
      end
    end
    
    # Include team members
    if Rails.application.config.feature_map.enabled?(:spark_teams)
      self.team_members.each do |user|
        to_return << user.email
      end
    end
    
    return to_return.uniq # dedupe
  end
end
