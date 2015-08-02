class OrdersController < ApplicationController
  def new 
    #render text: "#{@current_order.class} #{session[:current_order_id]} "
=begin
    @current_order ||=
    if current_customer 
      current_customer.orders.build
    else 
      order = Order.create
      session[:current_order_id] = order.id
    end
=end   
  end
  
  def index
  end

  def show 
  end

  def update
    #render text: "Orders#update params: #{params.inspect}"
    @current_order.order_items.each_with_index do |item, index| 
      item.update(quantity: params["item-#{index}"])
    end
    @current_order.calc_and_set_total_price
    redirect_to action: "new"
  end

  def destroy
    @current_order.destroy
    session[:current_order_id] = nil
    redirect_to books_path, notice: "Cart is empty now."
  end

  def add_to_order
    #render text: "Orders#add_to_order params: #{params.inspect}"
#=begin
    if @current_order 
      @current_order 
    else
      @current_order = Order.create
      session[:current_order_id] = @current_order.id
    end
    @book = Book.find(order_params[:book_id])
    @current_order.add_to_order(@book, order_params[:quantity])
    redirect_to action: "new"
#=end
  end 

  private 
  def order_params
    params.permit(:quantity, :book_id)
  end
end
