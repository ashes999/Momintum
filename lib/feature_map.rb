# Usage: if Rails.application.config.feature_map.enabled?(:email) ...
class FeatureMap
  def initialize(hash = nil)
    # Not necessary (empty values indicate it's enabled), but this is a good place
    # to list all the supported features. Please use only boolean values.
    @hash = hash || {
      :email => true,       # global email notifications
      :username => true,    # additional user name; used to log in
      :activity => true,    # activity/history on users/sparks
      :spark_likes => true, # users can like sparks
      :user_follows => true # users can follow other users
    }
    
  end
  
  def enabled?(feature)
    # Enabled if there's no config (default) or if it's not explicitly disabled
    raise 'Specify feature' if feature.nil?
    return true if !@hash.include?(feature.to_sym)
    return @hash[feature.to_sym]
  end
end