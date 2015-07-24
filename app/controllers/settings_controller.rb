class SettingsController < ApplicationController
  before_action :authenticate_customer!

  def index 
    #@shipping_address = current_customer.shipping_address || current_customer.shipping_address.build 
    @billing_address = Address.new#current_customer.billing_address || current_customer.billing_address.build 
    @countries = Country.all
  end

  def change_password
    if current_customer.valid_password?(password_params[:old_password]) && new_password.size >= 8
      customer = Customer.find(current_customer.id)
      new_password = password_params[:password]
      customer.password = new_password
      customer.save
      sign_in customer, :bypass => true
      redirect_to :back, notice: "Your password was successfully changed."
    elsif customer.valid_password?(password_params[:old_password]) && new_password.size < 8
      redirect_to :back, alert: "Sory, your new password should contain 8 characters minimum. Pls try again."
    else 
      redirect_to :back, alert: "You entered wrong current password. Pls try again."
    end
  end

  def change_personal_info

  end

  private

  def password_params
    params.require(:customer).permit(:old_password, :password)
  end
end
