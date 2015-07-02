class ChangeColumnsTypesInCreditCards < ActiveRecord::Migration
  def change
  	change_column :credit_cards, :number, :integer
  	change_column :credit_cards, :cvv, :integer
  	change_column :credit_cards, :exp_month, :integer
  	change_column :credit_cards, :exp_year, :integer
  end
end