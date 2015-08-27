class AddressesController < ApplicationController
  before_action :authenticate_customer!
  load_and_authorize_resource

  def update 
    if params[:address_type] == "billing" || (params[:address_type] == "shipping" && !params[:use_billing_as_shipping]) 
      if current_customer.billing_address != current_customer.shipping_address
        update_address(@address)  
      else 
        create
      end
    else
      save_billing_instead_of_shipping(@address)      
    end
  end

  def create 
    @address = Address.new(address_params)
    if @address.save
      set_customer_address_id(params[:address_type], @address.id)
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
    current_customer.update({"#{address_type}_address_id" => address_id}) 
    current_customer.update(shipping_address_id: @address.id) if address_type == "billing" && !current_customer.shipping_address
  end

  def update_address(address)
    if address.update(address_params)
      flash[:success] = "#{params[:address_type].capitalize}  address was successfully updated."
      redirect_to settings_path 
    else
      render_settings_with_errors 
    end
  end

  def save_billing_instead_of_shipping(address)
    if current_customer.billing_address
      address.destroy
      current_customer.update(shipping_address: current_customer.billing_address)
      flash[:success] = "Done! Now we will use your billing address also as shipping."
      redirect_to settings_path
    else
      flash[:error] = "You can't use billing address as shipping because you don't have it yet. Pls fill in form for billing address and save it first."
      redirect_to settings_path
    end
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