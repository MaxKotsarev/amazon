class RemoveDefaultStateInOrders < ActiveRecord::Migration
  def change
  	change_column_default(:orders, :state, nil)
  end
end
