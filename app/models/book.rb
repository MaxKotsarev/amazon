class Book < ActiveRecord::Base
  belongs_to :category
  belongs_to :author
  has_many :ratings

  validates_presence_of :title, :price, :amount
end
