class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :total_price
      t.datetime :completed_date
      t.string :state, :default => "in progress"
      t.references :customer, index: true, foreign_key: true
      t.references :creditcard, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
