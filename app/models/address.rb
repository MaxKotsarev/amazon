class Address < ActiveRecord::Base
  belongs_to :country

  validates_presence_of :address, :zipcode, :city, :phone, :country, :lastname, :firstname
end
