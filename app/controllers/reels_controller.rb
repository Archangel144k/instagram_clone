class ReelsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_reel, only: [:edit, :update, :destroy]
  
  def index
    @filter = params[:filter] || 'trending'
    
    case @filter
    when 'trending'
      @reels = Reel.trending
    when 'latest'
      @reels = Reel.recent
    when 'following'
      if user_signed_in?
        @reels = Reel.where(user_id: current_user.following_ids)
      else
        @reels = Reel.recent
      end
    else
      @reels = Reel.recent
    end
    
    @reels = @reels.includes(:user, :likes).page(params[:page]).per(12)
  end
  
  def show
    @reel = Reel.find(params[:id])
    # Disable browser caching for reel videos
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
    @reel.increment_view_count! # This increases the view count
    @comments = @reel.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new
  end
  
  def new
    @reel = current_user.reels.new
  end
  
  def create
    @reel = current_user.reels.build(reel_params)
    
    # Debug information
    Rails.logger.debug "PARAMS: #{params.inspect}"
    Rails.logger.debug "VIDEO PRESENT: #{params.dig(:reel, :video).present?}"
    Rails.logger.debug "VIDEO CLASS: #{params.dig(:reel, :video).class}"
    
    if @reel.save
      redirect_to @reel, notice: "Reel created successfully!"
    else
      Rails.logger.debug "ERRORS: #{@reel.errors.full_messages.join(', ')}"
      render :new
    end
  end
  
  def edit
    authorize @reel
  end
  
  def update
    authorize @reel
    if @reel.update(reel_params)
      redirect_to @reel, notice: 'Reel was successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    authorize @reel
    @reel.destroy
    redirect_to reels_path, notice: 'Reel was successfully deleted!'
  end
  
  private
  
  def set_reel
    @reel = Reel.find(params[:id])
  end
  
  def reel_params
    params.require(:reel).permit(:video, :caption, :audio_track)
  end
end