class SettingsController < ApplicationController
  before_action :authenticate_customer!
  before_action :fetch_data_for_settings_page

  def index 
  end

  def change_password
    render text: "SettingsController#change_password"
  end

  def change_personal_info
    current_customer.update(name_email_params)
    if current_customer.save
      flash[:success] = "Your data was successfully updated."
      redirect_to :controller => 'settings', :action => 'index'
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
