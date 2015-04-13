class SectionNote < ActiveRecord::Base
  
  validates :identifier, length: {minimum: 1, maximum: 4}
  validates_presence_of :status, :text, :identifier
  belongs_to :canvas_section
end
