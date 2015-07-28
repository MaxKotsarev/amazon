class SettingsController < ApplicationController
  before_action :authenticate_customer!
  before_action :fetch_data_for_settings_page

  def index 
  end

  def change_password
    old_pass = password_params[:old_password]
    new_pass = password_params[:new_password]

    if @customer.valid_password?(old_pass) && new_pass.size >= 8
      @customer.password = new_pass
      @customer.save
      sign_in @customer, :bypass => true
      flash[:success] = "Your password successfully changed."
      redirect_to :back
    elsif !@customer.valid_password?(old_pass) 
      redirect_to :back, error: "You entered wrong current password. Pls try again."
    else 
      redirect_to :back, error: "New password should have at least 8 characters. Pls try again."
    end
  end

  def change_personal_info
    @customer.update(name_email_params)
    if @customer.save
      flash[:success] = "Your data was successfully updated."
      redirect_to :back
    else
      flash.now[:error] = "You've got some errors. Check it below."
      render "settings/index"
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
