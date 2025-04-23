class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:mark_as_read]

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def mark_as_read
    @notification.mark_as_read!
    redirect_to notifications_path
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end
end