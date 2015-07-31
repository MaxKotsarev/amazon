class CreditCard < ActiveRecord::Base
  belongs_to :customer
  has_many :orders

  validates_presence_of :number, :cvv, :exp_month, :exp_year, :firstname, :lastname
  validates :number, length:  { is: 16 }
  validates :cvv, length:  { is: 3 }
  validates :exp_month, :exp_year, length:  { is: 2 }
  validates :number, :cvv, :exp_year, format: { with: /\A\d+$\z/ }
  validates :exp_month, format: { with: /\A(0+[1-9]|1+[12])\z/ }
  validates :exp_year, format: { with: /\A(1+[5-9]|[2-9]+[1-9])\z/ }

  def title 
    self.firstname + " " + self.lastname + " " + self.number
  end 
end
