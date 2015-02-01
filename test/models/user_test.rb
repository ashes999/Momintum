require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(:username => 'test', :email => 'test.user@test.com', :password => "test1234")
    @user.skip_confirmation! # skip emails if/when saved (eg. validation tests)
    if !@user.valid?
      raise "Test setup can't create a valid user: #{@user.errors.full_messages}"
    end
  end
  
  test "users with an empty email are not valid" do
    emails = [nil, '', '          ']
    emails.each do |e|
      @user.email = e
      assert_not(@user.valid?)
    end
  end
  
  test "emails under six characters are invalid" do
    emails = ['a', 'hi', 'c@t', 'c@t.a']
    emails.each do |e|
      @user.email = e
      assert_not(@user.valid?)
    end
  end
  
  test "emails 6-50 characters or longer are valid, but not longer" do
    @user.email = 'a@a.com'
    assert(@user.valid?, "#{@user.email} should be valid but isn't (#{@user.email.length} characters)")
    while (@user.email.length < 60)
      @user.email = "a#{@user.email}"
      
      if @user.email.length <= 50
        assert(@user.valid?) 
      else
        assert_not(@user.valid?)
      end
    end
  end
  
  test "emails must be unique (regardless of case)" do
    assert(@user.valid?)
    @user.save
    clone = User.new(:email => @user.email.upcase, :password => 'password', :username => @user.username)
    begin
      assert_not(clone.valid?)
    rescue
      @user.delete
    end
  end
  
  test "usernames must be unique (regardless of case)" do
    assert(@user.valid?)
    @user.save
    clone = User.new(:email => 'test.two@test.com', :password => 'password', :username => @user.username.upcase)
    begin
      assert_not(clone.valid?)
    rescue
      @user.delete
    end
  end
  
  test "users with an empty username are not valid" do
    emails = [nil, '', '          ']
    emails.each do |e|
      @user.username = e
      assert_not(@user.valid?)
    end
  end
  
  test "usernames 3-50 characters or longer are valid, but not shorter/longer" do
    @user.username = 'a'
    while (@user.username.length < 60)
      @user.username = "a#{@user.username}"
      
      if @user.username.length.between?(3, 50)
        assert(@user.valid?) 
      else
        assert_not(@user.valid?)
      end
    end
  end
  
  test "passwords must be eight characters or longer" do
    (1..30).each do |n|
      @user.password = 'a' * n
      assert_not(@user.valid?) if n <= 7
      assert(@user.valid?) if n > 7
    end
  end
end