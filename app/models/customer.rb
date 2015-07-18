class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :orders
  has_many :ratings

  validates_presence_of :email, :encrypted_password, :firstname, :lastname
  validates :email, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def create_new_order
    self.orders.create
  end

  def current_order
    self.orders.in_progress.last
  end
end
