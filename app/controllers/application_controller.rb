class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #rescue_from CanCan::AccessDenied do |exception|
  #  redirect_to main_app.root_path, :alert => exception.message
  #end

  # overriding CanCan::ControllerAdditions
  def current_auth_resource
    if admin_signed_in?
      current_admin
    else
      current_customer
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_auth_resource)
  end
end
