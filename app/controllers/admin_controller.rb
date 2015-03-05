class AdminController < ApplicationController
  before_action :authenticate_user!
  
  def dashboard
    not_found if ENV['ADMIN_EMAIL'].nil? || current_user.email != ENV['ADMIN_EMAIL']
  end
  
  def reload_features
    Rails.application.config.feature_map.reload
    redirect_to action: :dashboard
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
