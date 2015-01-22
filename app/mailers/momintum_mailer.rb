# inspired by https://github.com/plataformatec/devise/wiki/How-To:-Use-custom-mailer
class MomintumMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'mailers/devise' # changed from devise/mailers
  default from: Devise.mailer_sender
  
  def send_test_email()
    raise 'ADMIN_EMAIL environment variable not set' if ENV['ADMIN_EMAIL'].nil?
    raise 'TEST_ACCOUNT environment variable not set' if ENV['TEST_ACCOUNT'].nil?
    raise 'Devise.mailer_sender not set' if Devise.mailer_sender.nil?
    
    # Create a user so we get the confirmation email; then delete him.
    u = User.create(:email => ENV['TEST_ACCOUNT'])
    u.save!(:validate => false)
    u.delete
    
    # Send a separate email to the admin
    mail(:to => ENV['ADMIN_EMAIL'], :subject => 'Momintum Test Email', :body => "This is a test email sent from #{root_url}").deliver
  end
end