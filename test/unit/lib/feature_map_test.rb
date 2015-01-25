require 'test_helper'

class FeatureMapTest < ActiveSupport::TestCase
  test "features which are nil are enabled" do
    f = FeatureMap.new()
    assert_equal(true, f.enabled?(:email))
  end
  
  test "features with true are enabled" do
    f = FeatureMap.new({ :email => true })
    assert_equal(true, f.enabled?(:email))
  end
  
  test "features with false are disabled" do
    f = FeatureMap.new({ :email => false })
    assert_equal(false, f.enabled?(:email))
  end
end
