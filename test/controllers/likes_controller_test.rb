require 'test_helper'

class LikesControllerTest < ActionController::TestCase
  test "like creates like for user and spark" do
    base_count = Like.count
    u = User.new(:username => :test, :password => :password, :email => 'test@test.com')
    u.skip_confirmation!
    u.save
    
    s = Spark.create(:name => 'TBD', :summary => 'TBD', :description => 'TBD')
    
    sign_in(u)
    
    post :like, {:user_id => u.id, :spark_id => s.id}
    assert_response :redirect
    assert_equal(base_count + 1, Like.count)
    u.reload
    s.reload
    
    # Like created?
    l = u.likes.first
    assert_equal(s.id, l.spark_id)
    
    l = s.likes.first
    assert_equal(u.id, l.user_id)
    
    # Activity created?
    activity = s.activities.find_by(:key => :likes_spark)
    assert_not_nil(activity)
    
    assert_equal('user', activity.source_type)
    assert_equal(u.id, activity.source_id)
    assert_equal('spark', activity.target_type)
    assert_equal(s.id, activity.target_id)
  end
  
  test "dislike deletes like" do
    # We don't test the like :post method
    base_count = Like.count
    u = User.new(:username => :test, :password => :password, :email => 'test@test.com')
    u.skip_confirmation!
    u.save
    
    s = Spark.create(:name => 'TBD', :summary => 'TBD', :description => 'TBD')
    
    Like.create(:user_id => u.id, :spark_id => s.id)
    assert_equal(base_count + 1, Like.count)
    
    sign_in(u)
    get :dislike, { :user_id => u.id, :spark_id => s.id }
    assert_response :redirect
    assert_equal(base_count, Like.count)
  end

end
