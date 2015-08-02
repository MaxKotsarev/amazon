class OrderItemsController < ApplicationController
  def destroy
    @current_order.remove_from_order(params[:id])
    redirect_to new_order_path
  end
end