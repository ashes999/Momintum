require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  
  setup do
    @valid_types = [:user, :spark]
    
    @activity = Activity.new(:key => :created_spark, :source_type => :user,
      :source_id => 1, :target_type => :user, :target_id => 2)
      
    assert(@activity.valid?, "Can't create valid activity for validation tests: #{@activity.errors.full_messages}")
  end
  
  test 'source type must be a valid type' do
    @activity.source_type = :sword
    assert_not @activity.valid?
    
    @valid_types.each do |t|
      @activity.source_type = t
      assert @activity.valid?, "Source type #{t} should be valid"
    end
  end
  
  test 'target type must be a valid type' do
    @activity.target_type = :sword
    assert_not @activity.valid?
    
    @valid_types.each do |t|
      @activity.target_type = t
      assert @activity.valid?, "Target type #{t} should be valid"
    end
  end
end
