require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Mass Collaboration for the Ummah | Momintum"
  end
  
  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact Us | Momintum"
  end
  
  test "should get updates" do
    get :updates
    assert_response :success
    assert_select "title", "Updates | Momintum"
  end
end
