class FixColumnsTypesInCraditCards < ActiveRecord::Migration
  def change
  	change_column :credit_cards, :number, :string
  	change_column :credit_cards, :cvv, :string
  	change_column :credit_cards, :exp_month, :string
  	change_column :credit_cards, :exp_year, :string
  end
end
