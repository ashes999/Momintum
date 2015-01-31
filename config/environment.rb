# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Good place to change config (like mailer settings) since environment-specific
# code is already evaluated. MomintumMailer.delivery_method doesn't do anything.
ActionMailer::Base.delivery_method = :test if !Rails.application.config.feature_map.enabled?(:email)