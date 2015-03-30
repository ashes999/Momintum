class CanvasSection < ActiveRecord::Base
  
  belongs_to :spark
  validates_presence_of :spark
  has_many :section_notes

  # http://stackoverflow.com/a/1716632/210780
  def after_initialize
    # Make sure size is sane if not initialized
    @x ||= 0
    @y ||= 0
    @width ||= 300
    @height ||= 150
    @name ||= 'New Section'
  end
end
