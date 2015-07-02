class FixColumnNameInOrders < ActiveRecord::Migration
  def change
  	rename_column :orders, :creditcard_id, :credit_card_id
  end
end
