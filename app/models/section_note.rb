class SectionNote < ActiveRecord::Base
  
  validates_presence_of :status, :text
  belongs_to :canvas_section
end
