class Spark < ActiveRecord::Base
  
  validates :name,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }
  
  validates_presence_of :summary, :description
  
  belongs_to :owner,  :class_name => :User, :foreign_key => 'owner_id' 
  
  validates :owner, :presence => true
  
  def is_owner?(user)
    return !user.nil? && user.id == self.owner.id
  end
  
  def is_on_team?(user)
    return false
  end
end
