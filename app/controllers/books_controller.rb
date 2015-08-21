class BooksController < ApplicationController
  def index
    @books = Book.all.page(params[:page]).per(9)
    @categories = Category.all
  end

  def show 
    @book = Book.find(params[:id])
    @ratings = @book.ratings.approved
  end
end
