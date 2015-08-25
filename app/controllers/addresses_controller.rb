class AddressesController < ApplicationController
  before_action :authenticate_customer!
  load_and_authorize_resource

  def update 
    #@address = Address.find(params[:id])
    if params[:address_type] == "shipping"
      if current_customer.billing_address != current_customer.shipping_address && params[:use_billing_as_shipping]
        if current_customer.billing_address
          @address.destroy
          current_customer.shipping_address = current_customer.billing_address
          current_customer.save
          flash[:success] = "Done! Now we will use your billing address also as shipping."
          redirect_to settings_path and return
        else
          flash[:error] = "You can't use billing address as shipping because you don't have it yet. Pls fill in form for billing address and save it first."
          redirect_to settings_path and return
        end
      elsif current_customer.billing_address == current_customer.shipping_address
        create and return
      end
    end

    if @address.update(address_params)
      flash[:success] = "#{params[:address_type].capitalize}  address was successfully updated."
      redirect_to settings_path 
    else
      render_settings_with_errors 
    end
  end

  def create 
    @address = Address.new(address_params)
    if @address.save
      set_customer_address_id(params[:address_type], @address.id)
      flash[:success] = "#{params[:address_type].capitalize} address was successfully created."
      set_customer_address_id("shipping", @address.id) if params[:address_type] == "billing" && !current_customer.shipping_address
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

  def render_settings_with_errors
    fetch_data_for_settings_page
    reassign_address
    flash[:error] = "You've got some errors. Check it below."
    render 'customers/settings' 
  end 

  def reassign_address 
    if params[:address_type] == "billing"
      @billing_address = @address
    elsif params[:address_type] == "shipping"
      @shipping_address = @address 
    end
  end
end