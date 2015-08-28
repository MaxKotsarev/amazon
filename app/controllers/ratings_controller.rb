class RatingsController < ApplicationController
  before_action :find_book, only: [:new, :create]
  before_action :authenticate_customer!
  
  def new
    @rating = Rating.new
  end

  def create 
    @rating = current_customer.ratings.build(rating_params)
    if @rating.save
      redirect_to @book, notice: "Thank you for review! It will appear on this page after moderation."
    else    
      render 'new'
    end
  end

  private
  def rating_params
    params.require(:rating).permit(:review, :rating_number, :book_id)
  end

  def find_book
   @book = Book.find(params[:book_id])
  end
end
