class StoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @stories = Story.for_feed(current_user)
    Rails.logger.debug "Stories count: #{@stories.count}"
    Rails.logger.debug "Stories: #{@stories.map(&:id)}"
  end

  def show
    @story = Story.find_by(id: params[:id])
    if @story.nil?
      redirect_to stories_path, alert: "Story not found."
    end
  end

  def new
    @story = current_user.stories.new
  end

  def create
    @story = current_user.stories.new(story_params)

    if @story.save
      redirect_to stories_path, notice: "Your story was successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def story_params
    params.require(:story).permit(:media, :caption)
  end
end