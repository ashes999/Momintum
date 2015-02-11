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
end
