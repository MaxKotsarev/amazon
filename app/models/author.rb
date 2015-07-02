class Author < ActiveRecord::Base
	has_many :books

	validates_presence_of :firstname, :lastname
end
