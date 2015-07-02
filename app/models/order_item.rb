class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :book

  validates_presence_of :price, :quantity 
end
