# Usage: if Rails.application.config.feature_map.enabled?(:email) ...
class FeatureMap

  def initialize(hash = nil)
    if hash.nil?
      reload
    else
      @hash = hash
    end
  end
  
  def enabled?(feature)
    # Enabled if there's no config (default) or if it's not explicitly disabled
    raise 'Specify feature' if feature.nil?
    return true if !@hash.include?(feature.to_sym)
    return @hash[feature.to_sym]
  end
  
  # for convenience only (admin dashboard)
  def keys
    return @hash.keys
  end
  
  def reload
    map_path = 'config/feature_map.json'
    # Load the file and strip out comments
    contents = File.read(map_path)
    contents = contents.gsub(/#.*$/, '')
    # Convert to hash, preserving keys as symbols
    @hash = JSON.parse(contents, symbolize_names: true)
  end
end