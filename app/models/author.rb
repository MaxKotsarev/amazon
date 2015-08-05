class Author < ActiveRecord::Base
  has_many :books

  validates_presence_of :firstname, :lastname

  def title 
    "#{self.firstname} #{self.lastname}"
  end 
end
