class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :explore]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :unlike, :save, :unsave, :share]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.page(params[:page]).per(12)
    
    respond_to do |format|
      format.html
      format.js  # This enables the JavaScript response
    end
  end

  # GET /posts/1
  def show
    @post = Post.friendly.find(params[:id])
    @user = @post.user # Set the user associated with the post
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)
    
    # Debug information
    Rails.logger.debug "Attempting to save post: #{@post.attributes.inspect}"
    
    if @post.save
      Rails.logger.debug "Post was saved successfully"
      redirect_to @post, notice: 'Post was successfully created.'
    else
      Rails.logger.debug "Post failed to save: #{@post.errors.full_messages}" # Fixed this line
      render :new
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  # POST /posts/1/like
  def like
    @like = @post.likes.build(user: current_user)
    
    if @like.save
      respond_to do |format|
        format.html { redirect_back(fallback_location: posts_url) }
        format.turbo_stream
      end
    else
      redirect_back fallback_location: posts_url, alert: 'Could not like this post.'
    end
  end

  # DELETE /posts/1/unlike
  def unlike
    @like = @post.likes.find_by(user: current_user)
    
    if @like&.destroy
      respond_to do |format|
        format.html { redirect_back(fallback_location: posts_url) }
        format.turbo_stream
      end
    else
      redirect_back fallback_location: posts_url, alert: 'Could not unlike this post.'
    end
  end

  # POST /posts/1/save
  def save
    current_user.saved_posts << @post unless current_user.saved_posts.include?(@post)
    respond_to do |format|
      format.html { redirect_back(fallback_location: posts_url) }
      format.turbo_stream
    end
  end

  # DELETE /posts/1/unsave
  def unsave
    current_user.saved_posts.delete(@post)
    respond_to do |format|
      format.html { redirect_back(fallback_location: posts_url) }
      format.turbo_stream
    end
  end

  # POST /posts/1/share
  def share
    # Implementation depends on how you want to handle sharing
    # For now, redirecting back with success message
    redirect_back fallback_location: posts_url, notice: 'Post shared successfully.'
  end

  # GET /posts/explore
  def explore
    @posts = Post.order('RANDOM()').includes(:user, image_attachment: :blob).page(params[:page]).per(24)
  end

  # GET /posts/saved
  def saved
    @posts = current_user.saved_posts.includes(:user, image_attachment: :blob).page(params[:page]).per(12)
  end

  private
    # Use callbacks to share common setup or constraints between actions
    def set_post
      @post = Post.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through
    def post_params
      params.require(:post).permit(:caption, :image)
    end

    # Check if current user can edit/update/destroy post
    def authorize_user
      unless @post.user == current_user
        redirect_to posts_path, alert: "You're not authorized to perform this action."
      end
    end
end

class UsersController < ApplicationController
  before_action :set_user, only: [:follow, :unfollow]

  def follow
    current_user.follow(@user)
    redirect_to @user, notice: "You are now following #{@user.username}."
  end

  def unfollow
    current_user.unfollow(@user)
    redirect_to @user, notice: "You have unfollowed #{@user.username}."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
