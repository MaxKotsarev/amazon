class AddDeliveryTypeIdToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :delivery_type, index: true
  end
end
