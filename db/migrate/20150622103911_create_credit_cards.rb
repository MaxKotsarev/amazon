class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string :number
      t.string :cvv
      t.string :exp_month
      t.string :exp_year
      t.string :firstname
      t.string :lastname
      t.references :customer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
