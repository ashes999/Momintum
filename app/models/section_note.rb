class SectionNote < ActiveRecord::Base
  
  validates :identifier, length: {maximum: 4}, allow_blank: true
  validates_presence_of :status, :text, :identifier
  belongs_to :canvas_section
end
