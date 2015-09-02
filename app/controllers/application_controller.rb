class ApplicationController < ActionController::Base
  before_action :current_order
  after_filter :store_location
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
   redirect_to main_app.root_path, :alert => exception.message
  end

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

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get? 
    if (request.path != "/customers/sign_in" &&
        request.path != "/customers/sign_up" &&
        request.path != "/customers/sign_out" &&
        request.path != "/admins/sign_in" &&
        request.path != "/admins/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end

  def stored_location_for(resource) 
    session[:customer_return_to] || session[:admin_return_to]
  end


  def fetch_data_for_settings_page
    @billing_address = current_customer.billing_address || Address.new
    @shipping_address = current_customer.shipping_address || Address.new
    @countries = Country.all
  end


  def current_order
    @current_order = 
    if current_customer  
      if session[:current_order_id] && find_order_in_session.class == Order
        find_order_in_session.update(customer: current_customer) 
      end
      current_customer.current_order 
    elsif session[:current_order_id]
      find_order_in_session 
    end
  end

  def find_order_in_session
    Order.find_by(id: session[:current_order_id])
  end
end
