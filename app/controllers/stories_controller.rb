class StoriesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    @stories = Story.active.includes(:user).order(created_at: :desc)
  end

  def show
    @story = Story.find(params[:id])
  end

  def create
    @story = current_user.stories.new(story_params)

    if @story.save
      redirect_to stories_path, notice: "Story created successfully!"
    else
      redirect_to stories_path, alert: "Failed to create story."
    end
  end

  private

  def story_params
    params.require(:story).permit(:media)
  end
end
