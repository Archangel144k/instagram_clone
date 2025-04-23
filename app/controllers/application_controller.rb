class ApplicationController < ActionController::Base
  include PublicActivity::StoreController # This makes `current_user` available to PublicActivity

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name, :bio])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :name, :bio])
  end
end
