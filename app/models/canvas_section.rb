class CanvasSection < ActiveRecord::Base
  
  belongs_to :spark
  validates_presence_of :spark
  has_many :section_notes
  
  def initialize
    self.section_notes << SectionNote.new if self.section_notes.nil? || self.section_notes.count == 0
  end
end
