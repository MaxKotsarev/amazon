class PagesController < ApplicationController
  before_action :authenticate_customer!, only: [:settings]

  def index
  	@books = Book.last(3)
  end

  def shop
    @books = Book.all.page(params[:page]).per(9)
    @categories = Category.all
  end

  def settings
  end
end
