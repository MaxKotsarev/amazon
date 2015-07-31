class PagesController < ApplicationController
  def home
  	@books = Book.last(3)
  end
end
