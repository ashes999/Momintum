ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # only a user name is required
  def create_user(args)
    u = User.new(:username => args[:username], :email => args[:email] || "#{args[:username]}@#{args[:username]}.com", :password => args[:password] || 'password')
    u.skip_confirmation!
    u.save
    raise "Failed to create user: #{u.errors.messages}" if u.id == 0
    return u
  end
  
  # only a name is required
  def create_spark(args)
    name = args[:name]
    owner_id = args[:owner_id]
    s = Spark.create(:name => name, :summary => "Summary of #{name}", :description => "Description of #{name}", :owner_id => owner_id)
    raise "Failed to create spark: #{s.errors.messages}" if s.id == 0
    return s
  end
end

class ActionController::TestCase
  # Source of the sign_in method
  include Devise::TestHelpers
end