require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    u = User.create(:username => 'bobz', :email => 'bobz@uruncle.com', :password => 'password')
    
    get :show, :id => User.first.id
    u.destroy
    assert_response :success
  end
  
  ###
  # Authentication tests. These belong to Devise today; maybe something else tomorrow.
  ###
  
  test "creating a new user generates a welcome/confirmation email" do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      u = User.create(:username => :alice, :password => :password, :email => 'alibhai.ashiq@gmail.com')
      u.destroy
    end
    
    invite_email = ActionMailer::Base.deliveries.last
    assert_equal "Confirmation instructions", invite_email.subject
  end

  ### End of authentication tests ###

end
