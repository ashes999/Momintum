class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  def follow
    @user = current_user
    target_id = User.find(params[:target_id])
    raise 'Target ID not specified' if target_id.nil?
    target = User.find(target_id)
    Follow.create(:follower_id => @user.id, :target_id => target_id)
  end
end
