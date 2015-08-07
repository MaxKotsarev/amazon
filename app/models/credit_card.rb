class CreditCard < ActiveRecord::Base
  POSSIBLE_EXP_MONTHES = ["01","02","03","04","05","06","07","08","09","10","11","12"]
  POSSIBLE_EXP_YEARS = []
  (0..15).each do |i|
    POSSIBLE_EXP_YEARS << (Date.today.year.to_s.split("").last(2).join("").to_i + i).to_s
  end

  belongs_to :customer
  has_many :orders

  validates_presence_of :number, :cvv, :exp_month, :exp_year, :firstname, :lastname
  validates :number, length:  { is: 16 }
  validates :cvv, length:  { is: 3 }
  validates :exp_month, :exp_year, length:  { is: 2 }
  validates :number, :cvv, :exp_year, format: { with: /\A\d+$\z/ }
  #validates :exp_month, format: { with: /\A(0+[1-9]|1+[12])\z/ }
  #validates :exp_year, format: { with: /\A(1+[5-9]|[2-9]+[1-9])\z/ }

  validates :exp_month, inclusion: { in: POSSIBLE_EXP_MONTHES }
  validates :exp_year, inclusion: { in: POSSIBLE_EXP_YEARS }

  def title 
    self.firstname + " " + self.lastname + " " + self.number
  end 
end
