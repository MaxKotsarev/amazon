class AddressesController < ApplicationController
  before_action :authenticate_customer!

  def update 
  end

  def create 
    @address = current_customer
    render text: @address.inspect
=begin
    @address = Address.new(address_params)
    if @address.save
      redirect_to "settings/index", notice: "Billing address was successfully created"
    else
      redirect_to "settings/index", notice: "Somthing went wrong"
    end
=end
  end

  private
  def address_params 
    params.require(:address).permit(:firstname, :lastname, :address, :city, :country_id, :zipcode, :phone)
  end

  def find_address
    @address = current_customer.billing_address || current_customer.billing_address.build
  end 
end