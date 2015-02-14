class Spark < ActiveRecord::Base
  
  validates :name,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }
  
  validates_presence_of :summary, :description
  
  belongs_to :owner,  :class_name => :User, :foreign_key => 'owner_id' 
  
  def is_ownerless?
    return self.owner_id.nil? || self.owner.nil?
  end
  
  # name shown in the activity partial
  def activity_name
    return self.name
  end
  
  def activities
    to_return = Activity.where('(source_type = "spark" AND source_id = :id) OR (target_type = "spark" AND target_id = :id)',
      { :id => self.id })
  end
end
