class BooksController < ApplicationController
  def show 
    @book = Book.includes(:ratings).where(ratings: { approved: true }).find(params[:id])
  end
end
