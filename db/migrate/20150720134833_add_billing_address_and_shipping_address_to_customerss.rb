class AddBillingAddressAndShippingAddressToCustomerss < ActiveRecord::Migration
  def change
    add_reference :customers, :billing_address, index: true
    add_reference :customers, :shipping_address, index: true
  end
end
