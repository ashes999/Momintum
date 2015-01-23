class FeatureMap
  def initialize
    # Not necessary (empty values indicate it's enabled), but this is a good place
    # to list all the supported features. Please use only boolean values.
    @hash = {
      :email => false    # global email notifications
    }
  end
  
  def enabled?(feature)
    # Enabled if there's no config (default) or if it's not explicitly disabled
    raise 'Specify feature' if feature.nil?
    return true if !@hash.include?(feature.to_sym)
    return @hash[feature.to_sym]
  end
end

# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Rails.configuration.feature_map = FeatureMap.new