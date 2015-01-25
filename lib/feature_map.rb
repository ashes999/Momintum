class FeatureMap
  def initialize(hash = nil)
    # Not necessary (empty values indicate it's enabled), but this is a good place
    # to list all the supported features. Please use only boolean values.
    @hash = hash || {
      :email => true    # global email notifications
    }
  end
  
  def enabled?(feature)
    # Enabled if there's no config (default) or if it's not explicitly disabled
    raise 'Specify feature' if feature.nil?
    return true if !@hash.include?(feature.to_sym)
    return @hash[feature.to_sym]
  end
end