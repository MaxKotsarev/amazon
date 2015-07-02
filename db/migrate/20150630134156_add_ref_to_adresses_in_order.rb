class AddRefToAdressesInOrder < ActiveRecord::Migration
  def change
  	add_reference :orders, :billing_address, index: true
  	add_reference :orders, :shipping_address, index: true
  end
end
