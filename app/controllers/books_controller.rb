class BooksController < ApplicationController
  def show 
    #@book = Book.includes(:ratings).where(ratings: { approved: true }).find(params[:id])
    #не выбирает ничего, если у книги нет за-апрувленных рейтенгов :(
    #как это сделать красиво? (одним запросом)

    @book = Book.find(params[:id])
    @book.ratings = Rating.all.where(book: @book, approved: true)
  end
end
