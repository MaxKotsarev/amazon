class BooksController < ApplicationController
  def index
    @books = Book.all.page(params[:page]).per(9)
    @categories = Category.all
  end

  def show 
    #@book = Book.includes(:ratings).where(ratings: { approved: true }).find(params[:id])
    #не выбирает ничего (даже книгу), если у книги нет за-апрувленных рейтенгов :(
    #как это сделать красиво? (одним запросом)
    @book = Book.find(params[:id])
    #@book.ratings = Rating.all.where(book: @book, approved: true)
  end
end
