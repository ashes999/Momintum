# inspired by https://github.com/plataformatec/devise/wiki/How-To:-Use-custom-mailer
class MomintumMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'mailers/devise' # changed from devise/mailers
  
  def send_test_email()
    # Create a user so we get the confirmation email; then delete him.
    u = User.create(:email => 'guest@guest.com')
    u.save!(:validate => false)
    u.delete
  end
end