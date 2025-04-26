class SavesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :create_reel_save, :destroy_reel_save]

  rescue_from ActionController::RedirectBackError, with: :handle_redirect_error

  private

  def handle_redirect_error
    redirect_to root_path, alert: 'You need to sign in or sign up before continuing.'
  end

  # Save a post
  def create
    if params[:id].blank?
      redirect_back fallback_location: posts_path, alert: 'Invalid post ID.' and return
    end

    @post = Post.find_by(id: params[:id])
        format.html { redirect_back fallback_location: posts_path, notice: 'Post saved!' }
      redirect_back fallback_location: posts_path, alert: 'Post not found.' and return
    end

      redirect_back fallback_location: posts_path, alert: 'Unable to save post.'

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

    return redirect_back fallback_location: posts_path, alert: 'Invalid post.' if @post.nil?

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
        format.html { redirect_back fallback_location: reels_path, notice: 'Reel saved!' }
        format.js # For AJAX requests
      end
    else
      redirect_back fallback_location: reels_path, alert: 'Unable to save reel.'
    end
  end
  def destroy_reel_save
    if params[:id].blank?
      redirect_back fallback_location: reels_path, alert: 'Invalid reel ID.' and return
    end

    @reel = Reel.find_by(id: params[:id])
    if @reel.nil?
      redirect_back fallback_location: reels_path, alert: 'Reel not found.' and return
    end
      redirect_back fallback_location: reels_path, alert: 'Reel not found.' and return
    end

    if @reel.nil?
      redirect_back fallback_location: reels_path, alert: 'Reel not found.' and return
    end

    @save = current_user.saves.find_by(saveable: @reel)

    if @save&.destroy
      respond_to do |format|
        format.html { redirect_back fallback_location: reels_path, notice: 'Save removed!' }
        format.js # For AJAX requests
      end
    else
      redirect_back fallback_location: reels_path, alert: 'Unable to remove save.'
    end
  end
end