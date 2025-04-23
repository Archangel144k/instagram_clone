class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_user, only: [:show, :edit, :update, :followers, :following, :follow, :unfollow]
  before_action :authorize_user, only: [:edit, :update]
  
  def show
    @user = User.friendly.find(params[:id])
    @posts = @user.posts.includes(:likes, image_attachment: :blob).order(created_at: :desc)
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def followers
    @followers = @user.followers.includes(:avatar_attachment)
  end
  
  def following
    @following = @user.following.includes(:avatar_attachment)
  end

  def follow
    redirect_to login_path, alert: "Please sign in to follow users." and return unless current_user
    current_user.follow(@user)
    redirect_to @user, notice: "You are now following #{@user.username}."
  end

  def unfollow
    redirect_to login_path, alert: "Please sign in to unfollow users." and return unless current_user
    current_user.unfollow(@user)
    redirect_to @user, notice: "You have unfollowed #{@user.username}."
  end
  
  private
  
  def set_user
    @user = User.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "User not found"
    redirect_to root_path
  end
  
  def user_params
    params.require(:user).permit(:username, :email, :bio, :website, :avatar)
  end
  
  def authorize_user
    unless @user == current_user
      redirect_to @user, alert: "You're not authorized to edit this profile."
    end
  end
end