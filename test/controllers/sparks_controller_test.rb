require 'test_helper'

class SparksControllerTest < ActionController::TestCase
  setup do
    @controller = SparksController.new # sets controller for :get, etc.
    @user = User.new(:username => 'test', :email => 'test@test.com', :password => 'password')
    @user.skip_confirmation!
    @user.save
    @spark = Spark.create(:name => 'controller test', :description => 'test spark', :summary => 'test')
  end
  
  test "index has sparks" do
    get :index
    assert_not_nil assigns(:sparks)
    assert_response :success
    assert @controller.sparks.include?(@spark)
  end

  test "new requires signing in" do
    get :new
    assert_response :redirect
    assert_match(/#{new_user_session_path}/, @response.redirect_url)
  end
  
  test 'new succeeds when signed in' do
    sign_in(@user)
    get :new
    assert_response :success
  end

  test "should get show" do
    get :show, { :id => @spark.id }
    assert_response :success
  end

  test "edit requires signing in" do
    get :edit, { :id => @spark.id }
    assert_response :redirect
    assert_match(/#{new_user_session_path}/, @response.redirect_url)
  end
  
  test "edit gives flash notification if spark is deleted" do
    sign_in(@user)
    get(:edit, { :id => 999999 })
    assert(flash[:alert].include?('spark'))
  end
  
  test "edit gives flash notification if user is not spark owner" do
    sign_in(@user)
    user = User.new(:username => 'two', :email => 'two@test.com', :password => 'password')
    user.skip_confirmation!
    user.save
    
    s = Spark.create(:name => 'spark', :description => 'tbd', :summary => 'summary', :owner_id => user.id)
    get(:edit, { :id => s.id })
    assert(flash[:alert].include?('permission'))
  end
  
  test "edit gives flash notification if spark is ownerless" do
    sign_in(@user)
    user = User.new(:username => 'two', :email => 'two@test.com', :password => 'password')
    user.skip_confirmation!
    user.save
    
    s = Spark.create(:name => 'spark', :description => 'tbd', :summary => 'summary')
    get(:edit, { :id => s.id })
    assert(flash[:alert].include?('permission'))
  end
  
  test "edit edits the spark" do
    sign_in(@user)
    s = Spark.create(:name => 'spark', :description => 'tbd', :summary => 'summary', :owner_id => @user.id)
    patch :update, :id => s.id, :spark => { name: 'updated name', summary: 'updated summary', description: 'updated description' }
    s.reload
    
    assert_equal('updated name', s.name)
    assert_equal('updated summary', s.summary)
    assert_equal('updated description', s.description)
  end
end
