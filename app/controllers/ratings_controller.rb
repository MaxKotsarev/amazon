class RatingsController < ApplicationController
  before_action :find_book, only: [:new, :create]
  
  def new 
    @rating = Rating.new
    @params = params.inspect 
  end

  def create 
    @rating = current_customer.ratings.build(rating_params)
    @rating.book = @book
    if @rating.save
      redirect_to @book, notice: "Thank you for review! It will show up on this page after moderation."
    else 
      render 'new', alert: "Somthing went wrong. Try again pls."
    end
  end

  private
  def rating_params
    params.require(:rating).permit(:review, :rating_number)
  end

  def find_book
    @book = Book.find(params[:id])
  end
end
