class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:facebook]
         
  has_many :orders
  has_many :ratings, dependent: :destroy

  belongs_to :billing_address, class_name: "Address"
  belongs_to :shipping_address, class_name: "Address"

  validates_presence_of :email, :encrypted_password, :firstname, :lastname
  validates :email, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def create_new_order
    self.orders.create
  end

  def current_order
    self.orders.in_progress.last
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.firstname = auth.info.first_name   
      user.lastname = auth.info.last_name
    end
  end
end
