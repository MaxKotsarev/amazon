class AddressesController < ApplicationController
  before_action :authenticate_customer!

  def update 
  end

  def create 
    @address = Address.new(params[:firstname])
    if @address.save
      redirect_to "settings/index", notice: "Billing address was successfully created"
    else
      redirect_to "settings/index", notice: "Somting went wrong"
    end
  end

  def check_params
    redirect_to "settings/index", notice: "Look at params #{params}"
  end

  private
  def address_params 
    params.require(:billing_address).permit(:firstname, :lastname, :address, :city, :country_id, :zipcode, :phone)
  end

  def find_address
    @address = current_customer.billing_address || current_customer.billing_address.build
  end 
end