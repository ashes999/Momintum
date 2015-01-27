require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(:email => 'test.user@test.com')
  end
  
  test "users with an empty email are not valid" do
    emails = [nil, '', '          ']
    emails.each do |e|
      @user.email = e
      assert_not(@user.valid?)
    end
  end
end
