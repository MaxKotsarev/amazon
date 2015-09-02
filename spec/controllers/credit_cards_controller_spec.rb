require 'rails_helper'

RSpec.describe CreditCardsController, type: :controller do
  let(:book) { FactoryGirl.build_stubbed(:book) }
  let(:credit_card) { FactoryGirl.build(:credit_card) }
  let(:order) { FactoryGirl.build(:order) }
  let(:credit_card_params) { FactoryGirl.attributes_for(:credit_card).stringify_keys }

  describe "POST #create" do
    before do 
      @current_order.stub(:update)
    end

    it "assigns @credit_card" do 
      post :create, credit_card: credit_card_params 
      expect(assigns(:credit_card)).not_to be_nil
      #expect(assigns(:credit_card).number).to eq credit_card_params["number"]
    end

    context "with valid attributes" do
      before do 
        CreditCard.stub(:new).and_return credit_card
        credit_card.stub(:save).and_return true
        controller.instance_variable_set(:@current_order, order)
      end 

      xit "receives save for @credit_card" do
        expect_any_instance_of(CreditCard).to receive(:save)
        #expect(credit_card).to receive(:save)
        post :create, credit_card: credit_card_params
      end

      xit "receives update for @current_order" do
        expect(@current_order).to receive(:update)
        post :create, credit_card: credit_card_params
      end
  
      xit "redirects to checkout_confirm_orders_path" do
        post :create, credit_card: credit_card_params
        expect(response).to redirect_to checkout_confirm_orders_path
      end
    end

    context "with invalid attributes" do
      before do 
        CreditCard.stub(:new).and_return credit_card
        credit_card.stub(:save).and_return false
        post :create, credit_card: credit_card_params
      end 

      xit "renders 'new' template" do
        expect(response).to render_template 'orders/checkout_payment'
      end
    end 
  end
end
