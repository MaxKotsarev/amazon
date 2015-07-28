class AddressesController < ApplicationController
  before_action :authenticate_customer!

  def update 
    @address = Address.find(params[:id])
    @address.update(address_params)
    if @address.save
      flash[:success] = "#{params[:address_type].capitalize}  address was successfully updated."
      redirect_to settings_path 
    else
      render_settings_with_errors 
    end
  end

  def create 
    @address = Address.new(address_params)
    if @address.save
      @customer = Customer.find(current_customer.id) 
      set_customer_address_id(params[:address_type], @address.id)
      @customer.save
      flash[:success] = "#{params[:address_type].capitalize} address was successfully created."
      redirect_to settings_path 
    else
      render_settings_with_errors 
    end
  end

  private
  def address_params 
    params.require(:address).permit(:firstname, :lastname, :address, :city, :country_id, :zipcode, :phone)
  end

  def set_customer_address_id(address_type, address_id)
    current_customer.update_attributes({"#{address_type}_address_id" => address_id}) 
  end

  def reassign_address 
    if params[:address_type] == "billing"
      @billing_address = @address
    elsif params[:address_type] == "shipping"
      @shipping_address = @address 
    end
  end

  def render_settings_with_errors
    fetch_data_for_settings_page
    reassign_address
    flash[:error] = "You've got some errors. Check it below."
    render 'settings/index' 
  end
end