namespace :email do
  desc "Sends a test email using the Devise mailer"
  task test: :environment do
    result = MomintumMailer.send_test_email()
    # Email is not sent until we evaluate #{result}
    puts "Test email sent to #{ENV['ADMIN_EMAIL']} and registration to #{ENV['TEST_ACCOUNT']}. #{result}"
  end
end
