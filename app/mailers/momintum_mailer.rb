# inspired by https://github.com/plataformatec/devise/wiki/How-To:-Use-custom-mailer
class MomintumMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'mailers/devise' # changed from devise/mailers
  default from: Devise.mailer_sender || 'robot@momintum.com'
  
  def send_test_email()
    raise 'ADMIN_EMAIL environment variable not set' if ENV['ADMIN_EMAIL'].nil?
    raise 'Devise.mailer_sender not set' if Devise.mailer_sender.nil?
    
    # Create a user so we get the confirmation email; then delete him.
    u = User.create(:email => 'guest@guest.com')
    u.save!(:validate => false)
    u.delete
    
    # Also send a separate email to the admin
    mail(:to => Devise.mailer_sender, :subject => 'Momintum test email')
  end
end