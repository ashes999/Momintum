module ApplicationHelper
    
  TITLE_SUFFIX = 'Momintum'
  DEFAULT_TITLE = 'Mass Collaboration for the Ummah'
  
  # Returns the full title on a per-page basis.
  def title_or_default(page_title = '') # turn nil into empty
    if page_title.empty?
      title = DEFAULT_TITLE
    else
      title = page_title
    end
    
    return "#{title} | #{TITLE_SUFFIX}"
  end
    
end
