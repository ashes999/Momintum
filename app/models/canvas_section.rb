class CanvasSection < ActiveRecord::Base
  
  belongs_to :spark
  validates_presence_of :spark
  
end
