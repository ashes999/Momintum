require 'test_helper'

class SparksControllerTest < ActionController::TestCase
  setup do
    @controller = SparksController.new # sets controller for :get, etc.
    @user = User.new(:username => 'test', :email => 'test@test.com', :password => 'password')
    @user.skip_confirmation!
    @user.save
    assert @user.valid?, "Failed to create user: #{@user.errors.messages}"
    @spark = Spark.create(:name => 'controller test', :description => 'test spark', :summary => 'test')
    assert @spark.valid?, "Failed to create spark: #{@spark.errors.messages}"
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
  
  test "creating a spark creates an activity for that user and spark" do
    sign_in(@user)
    post :create, :spark => {name: 'activity test 1', summary: 'test spark', description: 'hi', owner_id: @user.id }
    s = Spark.find_by(:name => 'activity test 1')
    assert_not_nil(s)
    
    # spark activity
    assert_equal(1, s.activities.count)
    activity = s.activities.first
    assert_not_nil(activity)
    assert_equal('created_spark', activity.key)
    
    # user activity
    activity = @user.activities.find_by(:source_id => @user.id, :source_type => :user, :target_id => s.id, :target_type => :spark)
    assert_equal('created_spark', activity.key)
  end
  
  test "editing a spark creates an activity for that user and spark" do
    s = Spark.create(name: 'activity test 1', summary: 'test spark', description: 'hi', owner_id: @user.id)
    sign_in(@user)
    patch :update, { :id => s.id, :spark => { :name => s.name, :summary => s.summary, :description => 'updated description' }}
    
    # spark activity
    activity = s.activities.find_by(:key => 'updated_spark')
    assert_not_nil(activity)
    
    # user activity
    activity = @user.activities.find_by(:source_id => @user.id, :source_type => :user, :target_id => s.id, :target_type => :spark, :key => :updated_spark)
    assert_not_nil(activity)
  end
  
  ### "Follow" tests
  
  test "creating a new spark emails owner's followers" do
    owner = create_user(:username => 'owner')
    follower = create_user(:username => 'follower')
    Follow.create(:follower_id => follower.id, :target_id => owner.id)
    
    name = 'follow test new spark'
    sign_in(owner)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :create, :spark => {name: name, summary: 'test spark', description: 'hi', owner_id: owner.id }
      # Verify the spark exists
      assert_not_nil(Spark.find_by_name(name))
    end
    
    spark = Spark.last
    
    follow_email = ActionMailer::Base.deliveries.last
    assert_match "New Spark", follow_email.subject
    assert_match spark.name, follow_email.body.to_s
    assert_match 'new spark', follow_email.body.to_s
  end
  
  test "updating a spark description emails owner's followers and spark's likers" do
    owner = create_user(:username => 'owner')
    
    follower = create_user(:username => 'follower')
    Follow.create(:follower_id => follower.id, :target_id => owner.id)
    
    spark = create_spark(:name => 'spark 1', :owner_id => owner.id)
    
    liker = create_user(:username => 'liker')
    Like.create(:user_id => liker.id, :spark_id => spark.id)
    
    # No description change? No email.
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      spark.summary = 'Changed Summary!'
      spark.name = 'New Name!'
      spark.save
    end
    
    sign_in(owner)
    # Two emails: one to 'liker', and one to 'follower'
    assert_difference 'ActionMailer::Base.deliveries.size', +2 do
      patch :update, { :id => spark.id, :spark => { :name => spark.name, :summary => spark.summary, :description => "Updated on #{Time.new}" }}
    end
    
    follow_email = ActionMailer::Base.deliveries.last
    assert_match "Updated Spark", follow_email.subject
    assert_match spark.name, follow_email.body.to_s
    assert_match 'updated', follow_email.body.to_s
  end
  
  ### End of "Follow" tests
end
