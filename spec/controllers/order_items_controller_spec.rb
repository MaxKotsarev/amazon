require "rails_helper"

RSpec.describe OrderItemsController, type: :controller do 
  let(:order_item) {FactoryGirl.build_stubbed(:order_item)}
  let(:order) {FactoryGirl.build(:order)}

  describe "DELETE #destroy" do
    before do
      controller.instance_variable_set(:@current_order, order)
      @current_order.stub(:remove_from_order)
    end
    
    it "assign @books variable" do
      expect(@current_order).to receive(:remove_from_order).with(order_item.id.to_s) 
      delete :destroy, id: order_item.id
    end 

    it "redirects to 'new_order_path'" do 
      delete :destroy, id: order_item.id
      expect(response).to redirect_to new_order_path
    end
  end
end 
