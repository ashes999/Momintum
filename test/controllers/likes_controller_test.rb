require 'test_helper'

class LikesControllerTest < ActionController::TestCase
  test "like creates like for user and spark" do
    u = User.new(:username => :test, :password => :password, :email => 'test@test.com')
    u.skip_confirmation!
    u.save
    
    s = Spark.create(:name => 'TBD', :summary => 'TBD', :description => 'TBD')
    
    sign_in(u)
    
    assert_difference 'Like.count', +1 do
      post :like, {:user_id => u.id, :spark_id => s.id}
    end
    
    assert_response :redirect
    
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
    begin
      u = User.new(:username => :test, :password => :password, :email => 'test@test.com')
      u.skip_confirmation!
      u.save
    
      s = Spark.create(:name => 'TBD', :summary => 'TBD', :description => 'TBD')
      Like.create(:user_id => u.id, :spark_id => s.id)

      sign_in(u)

      assert_difference 'Like.count', -1 do
        delete :dislike, { :user_id => u.id, :spark_id => s.id }
      end
      
      assert_response :redirect
    ensure
      u.delete
      s.delete
    end
  end
  
  test "user can't like their own spark" do
    begin
      u = User.new(:username => :test, :password => :password, :email => 'test@test.com')
      u.skip_confirmation!
      u.save
      
      s = Spark.create(:name => 'TBD', :summary => 'TBD', :description => 'TBD', :owner_id => u.id)
      
      sign_in(u)
      post :like, {:user_id => u.id, :spark_id => s.id}
      
      # Didn't work: 0 likes, flash message
      l = u.likes
      assert_equal(0, l.count)
      assert(flash[:alert].include?('can\'t like'))
    ensure
      u.delete
      s.delete
    end
  end
  

end
