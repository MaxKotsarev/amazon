class CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :fetch_data_for_settings_page

  def settings 
  end

  def change_personal_info
    current_customer.update(name_email_params)
    if current_customer.save
      flash[:success] = "Your data was successfully updated."
      redirect_to settings_path
    else
      flash.now[:error] = "You've got some errors. Check it below."
      render "settings"
    end
  end

  def change_password
    if old_and_new_pass_ok?
      update_password
    elsif !old_pass_valid?
      redirect_to_settings_with_error("You entered wrong current password. Pls try again.")
    else 
      redirect_to_settings_with_error("New password should have at least 8 characters. Pls try again.")
    end
  end    

  private

  def update_password
    @customer = current_customer
    @customer.update(password: password_params[:new_password])
    sign_in @customer, :bypass => true
    flash[:success] = "Your password successfully changed."
    redirect_to settings_path
  end

  def redirect_to_settings_with_error(error_massage)
    flash[:error] = error_massage
    redirect_to settings_path
  end

  def password_params 
    params.require(:customer).permit(:old_password, :new_password)
  end

  def old_and_new_pass_ok?
    old_pass_valid? && password_params[:new_password].size >= 8
  end

  def old_pass_valid?
    current_customer.valid_password?(password_params[:old_password]) 
  end

  def name_email_params
    params.require(:customer).permit(:email, :lastname, :firstname)
  end
end
