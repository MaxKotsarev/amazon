class BooksController < ApplicationController
  def show 
    @book = Book.includes(:ratings).find(params[:id])
  end
end
