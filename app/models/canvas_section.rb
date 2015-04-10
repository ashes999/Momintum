class CanvasSection < ActiveRecord::Base
  
  belongs_to :spark
  validates_presence_of :spark
  has_many :section_notes

  # http://stackoverflow.com/a/29566511/210780
  after_initialize do |section|
    # Make sure size is sane if not initialized
    section.x ||= 0
    section.y ||= 0
    section.width ||= 300
    section.height ||= 150
    section.name ||= 'New Section'
  end
end
