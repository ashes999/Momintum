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
end
