class Rating < ActiveRecord::Base
  belongs_to :book
  belongs_to :customer

  validates_presence_of :rating_number, :review, :book, :customer

  scope :approved, -> {where(approved: true)}
end
