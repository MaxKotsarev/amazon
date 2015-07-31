class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :book

  validates_presence_of :price, :quantity, :book, :order

  def title 
  	self.quantity + " x " + self.book.title
  end
end
