require 'test_helper'

class SparkTest < ActiveSupport::TestCase
  
  def reset_spark
    @spark = Spark.new(:name => 'Test Spark', :summary => 'For testing only', :description => 'TBD')
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
    s1 = Spark.create(:name => @spark.name, :summary => 'A copy-cat', :description => 'Testing')
    
    begin
      assert_not(@spark.valid?)
    rescue
      s1.delete
    end
  end
  
  test "user owns sparks" do
    user = User.new(:username => 'test', :email => 'test.user@test.com', :password => "test1234")
    user.skip_confirmation! # skip emails if/when saved (eg. validation tests)
    user.save
    
    begin
      user2 = User.new(:username => 'test', :email => 'test.user@test.com', :password => "test1234")
      user2.skip_confirmation! # skip emails if/when saved (eg. validation tests)
      
      s1 = Spark.new(:name => 'Spark #1', :summary => 'Testing', :description => 'TBD', :user_id => user.id)
      s1.save
      
      s2 = Spark.new(:name => 'Spark #2', :summary => 'Testing', :description => 'TBD', :user_id => user2.id)
      s2.save
      
      assert(user.sparks.include?(s1))
      assert_not(user.sparks.include?(s2))
      
      assert_not(user2.sparks.include?(s1))
      assert(user2.sparks.include?(s2))
    rescue
      user.delete
      user2.delete unless user2.nil?
      s1.delete unless s1.nil?
      s2.delete unless s2.nil?
    end
end
