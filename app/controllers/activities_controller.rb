# filepath: app/controllers/activities_controller.rb
class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    # Fetch activities for users the current_user follows, plus their own
    following_ids = current_user.following.pluck(:id)
    user_ids = following_ids + [current_user.id]

    @activities = PublicActivity::Activity.where(owner_id: user_ids, owner_type: "User")
                                          .order(created_at: :desc)
                                          .includes(:owner, :trackable, :recipient) # Eager load
                                          .page(params[:page]).per(20) # Add pagination later if needed
  end
end