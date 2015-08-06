class CreditCardsController < ApplicationController
  def create
    @credit_card = CreditCard.new(credit_card_params)
    if @credit_card.save
      @current_order.update(credit_card: @credit_card)
      redirect_to checkout_confirm_orders_path
    else
      render checkout_payment_orders_path
    end
  end

  def update
    @credit_card = @current_order.credit_card
    if @credit_card.update(credit_card_params)
      redirect_to checkout_confirm_orders_path
    else
      render checkout_payment_orders_path
    end
  end

  private

  def credit_card_params
    params.require(:credit_card).permit(:number, :cvv, :lastname, :firstname, :exp_month, :exp_year) 
  end
end
