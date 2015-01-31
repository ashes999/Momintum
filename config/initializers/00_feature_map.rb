Rails.application.config.feature_map = FeatureMap.new

# Good place to change config (like mailer settings) since environment-specific
# code is already evaluated. MomintumMailer.delivery_method doesn't do anything.
ActionMailer::Base.delivery_method = :test if !Rails.application.config.feature_map.enabled?(:email)