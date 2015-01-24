class FeatureMap
  def initialize
    # Not necessary (empty values indicate it's enabled), but this is a good place
    # to list all the supported features. Please use only boolean values.
    @hash = {
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

# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.config.feature_map = FeatureMap.new

# Good place to change config (like mailer settings) since environment-specific
# code is already evaluated. MomintumMailer.delivery_method doesn't do anything.
ActionMailer::Base.delivery_method = :test if !Rails.application.config.feature_map.enabled?(:email)