class Spark < ActiveRecord::Base
  
  validates :name,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }
  
  validates_presence_of :summary, :description
  
  
end
