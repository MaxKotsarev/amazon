class CreateDeliveryTypes < ActiveRecord::Migration
  def change
    create_table :delivery_types do |t|
      t.string :title
      t.decimal :price
      t.timestamps null: false
    end
  end
end
