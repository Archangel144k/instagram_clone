class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]
  
  def create
    current_user.follow(@user)
    
    respond_to do |format|
      format.html { redirect_back(fallback_location: user_path(@user)) }
      format.turbo_stream
    end
  end
  
  def destroy
    current_user.unfollow(@user)
    
    respond_to do |format|
      format.html { redirect_back(fallback_location: user_path(@user)) }
      format.turbo_stream
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:user_id])
  end
end