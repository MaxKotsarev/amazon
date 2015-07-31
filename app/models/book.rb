class Book < ActiveRecord::Base
  belongs_to :category
  belongs_to :author
  has_many :ratings, dependent: :destroy#, -> { order 'created_at desc' }

  validates_presence_of :title, :price, :amount

  mount_uploader :image, ImageUploader
end
