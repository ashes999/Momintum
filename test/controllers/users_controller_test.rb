require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    u = User.new(:username => 'bobz', :email => 'bobz@uruncle.com', :password => 'password')
    u.skip_confirmation!
    u.save
    
    get :show, :id => User.first.id
    u.destroy
    assert_response :success
  end

end
