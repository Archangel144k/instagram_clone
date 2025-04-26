class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]

  def create
    current_user.follow(@user)
    
    # Send notification in background job if available
    NotificationWorker.perform_async('follow', current_user.id, @user.id) if defined?(NotificationWorker)

    respond_to do |format|
      format.html { redirect_back(fallback_location: user_path(@user)) }
      format.js
      format.json { 
        render json: { 
          success: true, 
          following: true,
          follower_count: @user.followers.count,
          message: "You are now following #{@user.username}"
        } 
      }
    end
  end

  def destroy
    current_user.unfollow(@user)
    
    respond_to do |format|
      format.html { redirect_back(fallback_location: user_path(@user)) }
      format.js
      format.json { 
        render json: { 
          success: true, 
          following: false,
          follower_count: @user.followers.count,
          message: "You have unfollowed #{@user.username}"
        } 
      }
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    
    unless @user
      respond_to do |format|
        format.html { redirect_to root_path, alert: "User not found" }
        format.json { render json: { success: false, error: "User not found" }, status: :not_found }
      end
    end
  end
end