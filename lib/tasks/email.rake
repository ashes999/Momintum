require 'feature_map'

namespace :email do
  desc "Sends a test email using the Devise mailer"
  task test: :environment do
    raise 'Email feature is disabled (see lib/feature_map.rb)' if !Rails.application.config.feature_map.enabled?(:email)
    result = MomintumMailer.test_email()
    # Email is not sent until we evaluate #{result}
    puts "Test email sent to #{ENV['ADMIN_EMAIL']} and registration to #{ENV['TEST_ACCOUNT']}. #{result}"
  end
end
