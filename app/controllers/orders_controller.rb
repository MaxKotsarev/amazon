class OrdersController < ApplicationController
  before_action :check_current_order, only: [:checkout_address, :checkout_delivery, :checkout_payment, :checkout_confirm]
  before_action :fetch_countries, only: [:checkout_address, :set_address]

  def new #cart   
  end
  
  def index #customer's orders list
  end

  def show #one order
  end

  def update #update cart
    @current_order.order_items.each_with_index do |item, index| 
      item.update(quantity: params["item-#{index}"])
    end
    @current_order.calc_and_set_total_price
    redirect_to action: "new"
  end

  def destroy #empty cart
    @current_order.destroy
    session[:current_order_id] = nil
    redirect_to books_path, notice: "Cart is empty now."
  end

  def add_to_order
    if @current_order 
      @current_order 
    else
      @current_order = Order.create
      session[:current_order_id] = @current_order.id
    end
    @book = Book.find(order_params[:book_id])
    @current_order.add_to_order(@book, order_params[:quantity])
    redirect_to action: "new"
  end 

#CHECKOUT WIZARD:
  #step 1
  def checkout_address
    assign_checkout_address_form
  end 

  def set_address
    #render text: params 
#=begin
    @checkout_address_form = CheckoutAddressForm.new(checkout_address_form_params)
    if @checkout_address_form.save(@current_order, current_customer)
      redirect_to checkout_delivery_orders_path
    else
      render "checkout_address"
    end
#=end
  end 

  #step 2
  def checkout_delivery
  end 

  def set_delivery
  end 

  #step 3
  def checkout_payment
  end 

  def set_payment
  end 

  #step 4
  def checkout_confirm
  end 

  #step 5
  def checkout_complete
  end 


  private 
  def order_params
    params.permit(:quantity, :book_id)
  end

  def checkout_address_form_params
    params.require(:checkout_address_form).permit(:b_firstname, 
                                                  :b_lastname, 
                                                  :b_address, 
                                                  :b_city, 
                                                  :b_country_id, 
                                                  :b_zipcode, 
                                                  :b_phone, 
                                                  :s_firstname, 
                                                  :s_lastname, 
                                                  :s_address, 
                                                  :s_city, 
                                                  :s_country_id, 
                                                  :s_zipcode, 
                                                  :s_phone,
                                                  :use_billing_as_shipping)
  end

  def assign_checkout_address_form
    @checkout_address_form = CheckoutAddressForm.new
    unless fetch_addresses_from(@current_order)
      fetch_addresses_from(current_customer) if current_customer
    end
  end

  def fetch_addresses_from(order_or_customer)
    if order_or_customer.shipping_address
      @ba = order_or_customer.billing_address if order_or_customer.billing_address
      @sa = order_or_customer.shipping_address unless order_or_customer.billing_address == order_or_customer.shipping_address
      assign_bill_address_fields(@checkout_address_form, @ba) if @ba
      assign_ship_address_fields(@checkout_address_form, @sa) if @sa
      true
    else 
      false
    end
  end

  def assign_bill_address_fields(form, ba)
    form.b_firstname = ba.firstname
    form.b_lastname = ba.lastname 
    form.b_address = ba.address 
    form.b_city = ba.city
    form.b_country_id = ba.country_id
    form.b_zipcode = ba.zipcode
    form.b_phone = ba.phone
  end 

  def assign_ship_address_fields(form, sa)
    form.s_firstname = sa.firstname
    form.s_lastname = sa.lastname 
    form.s_address = sa.address 
    form.s_city = sa.city
    form.s_country_id = sa.country_id
    form.s_zipcode = sa.zipcode
    form.s_phone = sa.phone
    form.use_billing_as_shipping = false
  end 

  def check_current_order
    redirect_to action: "new" unless @current_order
  end 

  def fetch_countries 
    @countries = Country.all
  end
end
