class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @reel = Reel.find(params[:id])
    @like = @reel.likes.new(user: current_user)

    if @like.save
      respond_to do |format|
        format.html { redirect_back fallback_location: reel_path(@reel), notice: 'Reel liked!' }
        format.js # For AJAX requests
      end
    else
      redirect_back fallback_location: reel_path(@reel), alert: 'Unable to like reel.'
    end
  end

  def destroy
    @reel = Reel.find(params[:id])
    @like = @reel.likes.find_by(user: current_user)

    if @like&.destroy
      respond_to do |format|
        format.html { redirect_back fallback_location: reel_path(@reel), notice: 'Like removed!' }
        format.js # For AJAX requests
      end
    else
      redirect_back fallback_location: reel_path(@reel), alert: 'Unable to remove like.'
    end
  end
end