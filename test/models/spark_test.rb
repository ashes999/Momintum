require 'test_helper'

class SparkTest < ActiveSupport::TestCase
  
  def reset_spark
    @spark = Spark.new(:name => 'Test Spark', :summary => 'For testing only', :description => 'TBD')
    
    @user = User.new(:username => 'test', :email => 'test.user@test.com', :password => :password)
    @user.skip_confirmation! # skip emails if/when saved (eg. validation tests)
    @user.save
  end
  
  setup do
    reset_spark
    assert(@spark.valid?, 'Failed to create valid spark in test setup')
  end
  
  test "name summary and description are required" do
    @spark.name = ''
    assert_not(@spark.valid?)
    
    reset_spark
    @spark.summary = ''
    assert_not(@spark.valid?)
    
    reset_spark
    @spark.description = ''
    assert_not(@spark.valid?)
  end
  
  test "spark names must be unique" do
    Spark.create(:name => @spark.name, :summary => 'A copy-cat', :description => 'Testing', :owner_id => @user.id)
    assert_not(@spark.valid?)
  end
  
  test "user owns sparks" do

    user = User.new(:username => 'test2', :email => 'test.one@test.com', :password => :password)
    user.skip_confirmation!
    user.save
    
    user2 = User.new(:username => 'test3', :email => 'test.two@test.com', :password => :password)
    user2.skip_confirmation!
    user2.save
    
    s1 = Spark.new(:name => 'Spark #1', :summary => 'Testing', :description => 'TBD', :owner_id => user.id)
    assert s1.save
    
    s2 = Spark.new(:name => 'Spark #2', :summary => 'Testing', :description => 'TBD', :owner_id => user2.id)
    assert s2.save
    
    # Ensure collections in-memory are up-to-date
    user.sparks.reload
    user2.sparks.reload
    
    assert(user.sparks.include?(s1))
    assert_not(user.sparks.include?(s2))
    
    assert_not(user2.sparks.include?(s1))
    assert(user2.sparks.include?(s2))
    
  end
  
  test "deleting a user makes their sparks ownerless" do
    user = User.new(:username => 'test2', :email => 'test.user@test.com', :password => :password)
    user.skip_confirmation!
    user.save
    
    spark = Spark.create(:name => 'Test spark', :summary => 'User deletion test', :description => 'TBA', :owner_id => user.id)
    id = spark.id
    user.delete
    s = Spark.find(id)
    assert s.ownerless?
  end
  
  test "ownerless? returns true if owner_id is nil" do
    s = Spark.new(:name => 'One', :summary => 'Two', :description => 'Three')
    assert(s.ownerless?)
    
    s.owner = @user
    assert_not(s.ownerless?)
  end
end
