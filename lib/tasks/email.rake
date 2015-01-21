namespace :email do
  desc "Sends a test email using the Devise mailer"
  task test: :environment do
    MomintumMailer.send_test_email()
    puts "Emails sent to guest@guest.com (from #{Devise.mailer_sender}). Check the GMail outbox for confirmation."
  end
end
