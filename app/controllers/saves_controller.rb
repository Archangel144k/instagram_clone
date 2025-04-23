class SavesController < ApplicationController
  before_action :authenticate_user!

  # Save a post
  def create
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      redirect_back fallback_location: posts_path, alert: 'Post not found.' and return
    end

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

  # Remove a saved post
  def destroy
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      redirect_back fallback_location: posts_path, alert: 'Post not found.' and return
    end

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

  # Save a reel
  def create_reel_save
    @reel = Reel.find_by(id: params[:id])
    if @reel.nil?
      redirect_back fallback_location: reels_path, alert: 'Reel not found.' and return
    end

    @save = current_user.saves.new(saveable: @reel)

    if @save.save
      respond_to do |format|
        format.html { redirect_back fallback_location: reel_path(@reel), notice: 'Reel saved!' }
        format.js # For AJAX requests
      end
    else
      redirect_back fallback_location: reel_path(@reel), alert: 'Unable to save reel.'
    end
  end

  # Remove a saved reel
  def destroy_reel_save
    @reel = Reel.find_by(id: params[:id])
    if @reel.nil?
      redirect_back fallback_location: reels_path, alert: 'Reel not found.' and return
    end

    @save = current_user.saves.find_by(saveable: @reel)

    if @save&.destroy
      respond_to do |format|
        format.html { redirect_back fallback_location: reel_path(@reel), notice: 'Save removed!' }
        format.js # For AJAX requests
      end
    else
      redirect_back fallback_location: reel_path(@reel), alert: 'Unable to remove save.'
    end
  end
end