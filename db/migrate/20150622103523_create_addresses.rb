class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :zipcode
      t.string :city
      t.string :phone
      t.references :country, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
