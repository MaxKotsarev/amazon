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
    old_pass = password_params[:old_password]
    new_pass = password_params[:new_password]

    if current_customer.valid_password?(old_pass) && new_pass.size >= 8
      @customer = current_customer
      @customer.update(password: new_pass)
      sign_in @customer, :bypass => true
      flash[:success] = "Your password successfully changed."
      redirect_to settings_path
    elsif !current_customer.valid_password?(old_pass) 
      flash[:error] = "You entered wrong current password. Pls try again."
      redirect_to settings_path
    else 
      flash[:error] = "New password should have at least 8 characters. Pls try again."
      redirect_to settings_path
    end
  end    

  private

  def password_params 
    params.require(:customer).permit(:old_password, :new_password)
  end

  def name_email_params
    params.require(:customer).permit(:email, :lastname, :firstname)
  end
end
