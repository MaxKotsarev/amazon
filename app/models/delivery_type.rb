class DeliveryType < ActiveRecord::Base
	validates_presence_of :title, :price
end
