class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    # Check if already liked to prevent duplicates
    if current_user.likes?(@post)
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path }
        format.json { render json: { success: true, liked: true, count: @post.likes.count } }
      end
      return
    end
    
    @like = @post.likes.build(user: current_user)
    
    if @like.save
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "Post liked!" }
        format.json { render json: { success: true, liked: true, count: @post.likes.count } }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "Could not like post." }
        format.json { render json: { success: false, errors: @like.errors.full_messages } }
      end
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    
    if @like&.destroy
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "Like removed." }
        format.json { render json: { success: true, liked: false, count: @post.likes.count } }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "Could not unlike post." }
        format.json { render json: { success: false, errors: ["Unable to unlike this post"] } }
      end
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])
    
    unless @post
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "Post not found." }
        format.json { render json: { success: false, errors: ["Post not found"] }, status: :not_found }
      end
    end
  end
end