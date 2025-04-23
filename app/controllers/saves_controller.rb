class SavesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:id])
    @save = current_user.saves.new(saveable: @post)

    if @save.save
      respond_to do |format|
        format.html { redirect_back fallback_location: post_path(@post), notice: 'Post saved!' }
        format.js # For AJAX requests
      end
    else
      redirect_back fallback_location: post_path(@post), alert: 'Unable to save post.'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @save = current_user.saves.find_by(saveable: @post)

    if @save&.destroy
      respond_to do |format|
        format.html { redirect_back fallback_location: post_path(@post), notice: 'Save removed!' }
        format.js # For AJAX requests
      end
    else
      redirect_back fallback_location: post_path(@post), alert: 'Unable to remove save.'
    end
  end
end