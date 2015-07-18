class PagesController < ApplicationController
  def index
  end

  def shop
    @books = Book.all.page(params[:page]).per(9)
    @categories = Category.all
  end
end
