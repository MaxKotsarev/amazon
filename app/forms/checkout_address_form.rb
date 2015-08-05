class CheckoutAddressForm
  include ActiveModel::Model
  include Virtus

  # Attributes (DSL provided by Virtus)
  #fields for billing address
  attribute :b_firstname, String
  attribute :b_lastname, String
  attribute :b_address, String
  attribute :b_city, String
  attribute :b_country_id, Integer
  attribute :b_zipcode, String
  attribute :b_phone, String
  #fields for shipping address
  attribute :s_firstname, String
  attribute :s_lastname, String
  attribute :s_address, String
  attribute :s_city, String
  attribute :s_country_id, Integer
  attribute :s_zipcode, String
  attribute :s_phone, String

  attribute :use_billing_as_shipping, Boolean, default: true

  # Access the expense record after it's saved
  #attr_reader :expense

  # Validations
  validates_presence_of :b_address, :b_zipcode, :b_city, :b_phone, :b_country_id, :b_lastname, :b_firstname
  validates_presence_of :s_address, :s_zipcode, :s_city, :s_phone, :s_country_id, :s_lastname, :s_firstname,  unless: "use_billing_as_shipping"

  def save(current_order, current_customer)
    if valid?
      persist!(current_order, current_customer)
      true
    else
      false
    end
  end

  def persisted?
    false
  end


  private

  def persist!(current_order, current_customer)
    [current_order, current_customer].each do |order_or_customer|
      if order_or_customer
        save_bill_address_for(order_or_customer)
        save_ship_address_for(order_or_customer)
      end 
    end   
  end

  def save_bill_address_for(order_or_customer)
    if order_or_customer.billing_address
      order_or_customer.billing_address.update(b_address_params)
    else
      order_or_customer.billing_address = Address.create(b_address_params)
    end
    order_or_customer.save 
  end

  def save_ship_address_for(order_or_customer)
    if use_billing_as_shipping
      unless (order_or_customer.billing_address == order_or_customer.shipping_address) && order_or_customer.shipping_address 
        order_or_customer.shipping_address.destroy if order_or_customer.shipping_address
        order_or_customer.shipping_address = order_or_customer.billing_address
      end
    else 
      if (order_or_customer.billing_address != order_or_customer.shipping_address) && order_or_customer.shipping_address 
        order_or_customer.shipping_address.update(s_address_params) 
      else
        order_or_customer.shipping_address = Address.create(s_address_params)
      end
    end
    order_or_customer.save 
  end

  def b_address_params
    {firstname: b_firstname, lastname: b_lastname, address: b_address, city: b_city, country_id: b_country_id, zipcode: b_zipcode, phone: b_phone}
  end

  def s_address_params
    {firstname: s_firstname, lastname: s_lastname, address: s_address, city: s_city, country_id: s_country_id, zipcode: s_zipcode, phone: s_phone}
  end
end