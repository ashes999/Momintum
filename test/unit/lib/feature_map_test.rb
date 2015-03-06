require 'test_helper'

class FeatureMapTest < ActiveSupport::TestCase
  test "features which are nil are enabled" do
    f = FeatureMap.new
    assert_equal(true, f.enabled?(:polymorphic_widgets))
  end
  
  test "features with true are enabled" do
    f = FeatureMap.new({ :flying_cats => true })
    assert_equal(true, f.enabled?(:flying_cats))
  end
  
  test "features with false are disabled" do
    f = FeatureMap.new({ :email => false })
    assert_equal(false, f.enabled?(:email))
  end
end
