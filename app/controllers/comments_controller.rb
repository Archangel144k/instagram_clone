class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params.merge(user: current_user))

    if @comment.save
      respond_to do |format|
        format.html { redirect_back fallback_location: post_path(@post), notice: 'Comment added!' }
        format.js # For AJAX requests
      end
    else
      redirect_back fallback_location: post_path(@post), alert: 'Unable to add comment.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end