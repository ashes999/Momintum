require 'test_helper'

class SparkUserTest < ActionController::TestCase
  
  setup do
    @controller = SparksController.new # sets controller for :get, etc.
    @user = User.new(:username => 'test', :email => 'test@test.com', :password => 'password')
    @user.skip_confirmation!
    @user.save
    sign_in(@user)
  end
  
  teardown do
    @user.destroy unless @user.nil?
  end
  
  test "edit gives flash notification if spark is deleted" do
    get(:edit, { :id => 999999 })
    assert(flash[:alert].include?('spark'))
  end
  
  test "edit gives flash notification if user is not spark owner" do
    user = User.new(:username => 'two', :email => 'two@test.com', :password => 'password')
    user.skip_confirmation!
    user.save
    
    s = Spark.create(:name => 'spark', :description => 'tbd', :summary => 'summary', :owner_id => user.id)
    get(:edit, { :id => s.id })
    assert(flash[:alert].include?('permission'))
  end
  
  test "edit gives flash notification if spark is ownerless" do
    user = User.new(:username => 'two', :email => 'two@test.com', :password => 'password')
    user.skip_confirmation!
    user.save
    
    s = Spark.create(:name => 'spark', :description => 'tbd', :summary => 'summary')
    get(:edit, { :id => s.id })
    assert(flash[:alert].include?('permission'))
  end
end
