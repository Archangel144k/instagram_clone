class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:id])
    @like = @post.likes.new(user: current_user)

    if @like.save
      respond_to do |format|
        format.html { redirect_back fallback_location: post_path(@post), notice: 'Post liked!' }
        format.js # For AJAX requests
      end
    else
      redirect_back fallback_location: post_path(@post), alert: 'Unable to like post.'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @like = @post.likes.find_by(user: current_user)

    if @like&.destroy
      respond_to do |format|
        format.html { redirect_back fallback_location: post_path(@post), notice: 'Like removed!' }
        format.js # For AJAX requests
      end
    else
      redirect_back fallback_location: post_path(@post), alert: 'Unable to remove like.'
    end
  end
end