require 'rails_helper'

RSpec.describe AddressesController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer) }
  let(:address) { FactoryGirl.create(:address) }
  let(:address_params) { FactoryGirl.attributes_for(:address).stringify_keys }
  let(:address_2) { FactoryGirl.create(:address) }
  let(:ability) { Ability.new(customer) }

  before do
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    sign_in :customer, customer
  end

  describe 'PATCH #update' do 
    it "assigns @adress" do
      patch :update, id: address.id
      expect(assigns(:address)).to eq address 
    end

    it "calls #update_address(@address) if method #need_to_update_address? returns true" do
      controller.stub(:need_to_update_address?).and_return true
      controller.stub(:update_address) 
      controller.stub(:render)
      expect(controller).to receive(:update_address).with(address)
      patch :update, id: address.id
    end

    it "calls #create if method #need_to_create_new_shipping_address? returns true" do 
      controller.stub(:need_to_update_address?).and_return false
      controller.stub(:need_to_create_new_shipping_address?).and_return true
      controller.stub(:create) 
      controller.stub(:render)
      expect(controller).to receive(:create)
      patch :update, id: address.id
    end

    it "calls #save_billing_instead_of_shipping(@address) if #need_to_update_address? and #need_to_create_new_shipping_address? returns false" do 
      controller.stub(:need_to_update_address?).and_return false
      controller.stub(:need_to_create_new_shipping_address?).and_return false
      controller.stub(:save_billing_instead_of_shipping) 
      controller.stub(:render)
      expect(controller).to receive(:save_billing_instead_of_shipping).with(address)
      patch :update, id: address.id
    end
  end

  describe "#need_to_update_address?" do 
    subject { controller.send(:need_to_update_address?) }

    it "returns true if data comes from billing address form" do
      controller.params[:address_type] ="billing"
      expect(subject).to eq true
    end 

    it "returns true if data comes from shipping address form with unchecked 'use bill as ship' and current customer billing address not the same as shipping" do
      controller.params[:address_type] = "shipping"
      controller.params[:use_billing_as_shipping] = false
      customer.update(billing_address: address, shipping_address: address_2)
      expect(subject).to eq true
    end

    it "returns false if data comes from shipping address form with cheked 'use bill as ship'" do
      controller.params[:address_type] ="shipping"
      controller.params[:use_billing_as_shipping] = true
      expect(subject).to eq false
    end 

     it "returns false if data comes from shipping address form with unchecked 'use bill as ship' and current customer billing address the same as shipping" do
      controller.params[:address_type] ="shipping"
      controller.params[:use_billing_as_shipping] = false
      customer.update(billing_address: address, shipping_address: address)
      expect(subject).to eq false
    end
  end 

  describe "#need_to_create_new_shipping_address?" do 
    subject { controller.send(:need_to_create_new_shipping_address?) }

    it "returns true if data comes from shipping address form with unchecked 'use bill as ship' and current customer billing address the same as shipping" do
      controller.params[:address_type] ="shipping"
      controller.params[:use_billing_as_shipping] = false
      customer.update(billing_address: address, shipping_address: address)
      expect(subject).to eq true
    end 

    it "returns false if data comes from shipping address form with unchecked 'use bill as ship' and current customer billing address not the same as shipping" do
      controller.params[:address_type] ="shipping"
      controller.params[:use_billing_as_shipping] = false
      customer.update(billing_address: address, shipping_address: address_2)
      expect(subject).to eq false
    end

    it "returns false if data comes from shipping address form with cheked 'use bill as ship'" do
      controller.params[:address_type] ="shipping"
      controller.params[:use_billing_as_shipping] = true
      expect(subject).to eq false
    end 

     it "returns false if data comes from billing address form" do
      controller.params[:address_type] ="billing"
      expect(subject).to eq false
    end
  end

  describe "#update_address(address)" do 
    before { controller.stub(:address_params).and_return address_params }

    context "with valid attributes" do 
      before do 
        address.stub(:update).and_return true
        controller.params[:address_type] ="billing" 
        controller.stub(:redirect_to)
      end 

      it "receives #update for address" do 
        expect(address).to receive(:update).with(address_params) 
        controller.send(:update_address, address)
      end 

      it "sends success notice (with capitalized address type interpolation)" do 
        controller.send(:update_address, address)
        expect(flash[:success]).to eq 'Billing address was successfully updated.'
      end

      it "redirects to settings_path" do 
        expect(controller).to receive(:redirect_to).with(settings_path)
        controller.send(:update_address, address)
      end
    end 

    context "with invalid attributes" do 
      before do 
        address.stub(:update).and_return false
        controller.stub(:render_settings_with_errors)
      end 

      it "calls method #render_settings_with_errors" do
        expect(controller).to receive(:render_settings_with_errors)
        controller.send(:update_address, address)
      end
    end 
  end

  describe "#save_billing_instead_of_shipping(address)" do
    before do
      controller.stub(:current_customer).and_return customer
      controller.stub(:redirect_to)
    end

    context "current customer has billing address" do
      before do
        customer.stub(:billing_address).and_return address
        address.stub(:destroy)
        customer.stub(:update)
      end
      
      it "calls destroy for address" do 
        expect(address).to receive(:destroy)
        controller.send(:save_billing_instead_of_shipping, address)
      end

      it "calls update for current customer" do 
        expect(customer).to receive(:update)#.with(shipping_address: address)
        controller.send(:save_billing_instead_of_shipping, address)
      end

      it "send success flash massage" do
        controller.send(:save_billing_instead_of_shipping, address)
        expect(flash[:success]).to eq 'Done! Now we will use your billing address also as shipping.'
      end 

      it "redirects to settings_path" do 
        expect(controller).to receive(:redirect_to).with(settings_path)
        controller.send(:save_billing_instead_of_shipping, address)
      end
    end 
    
    context "current customer hasn't billing address" do
      before do
        customer.stub(:billing_address).and_return false
      end

      it "send error flash massage" do
        controller.send(:save_billing_instead_of_shipping, address)
        expect(flash[:error]).to eq "You can't use billing address as shipping because you don't have it yet. Pls fill in form for billing address and save it first."
      end 

      it "redirects to settings_path" do 
        expect(controller).to receive(:redirect_to).with(settings_path)
        controller.send(:save_billing_instead_of_shipping, address)
      end
    end 
  end

  describe "POST #create" do
    before do 
      controller.stub(:address_params).and_return address_params 
    end

    it "assigns @address" do
      post :create
      expect(assigns(:address)).to be_a_new(Address)  
    end 

    context "with valid attributes" do 
      before do 
        Address.any_instance.stub(:save).and_return true
        controller.stub(:set_customer_address_id)
      end 

      it "calls #set_customer_address_id" do 
        expect(controller).to receive(:set_customer_address_id)
        post :create, address_type: "billing"
      end  

      it "sends success notice (with capitalized address type interpolation)" do 
        post :create, address_type: "billing"
        expect(flash[:success]).to eq 'Billing address was successfully created.'
      end

      it "redirects to settings_path" do 
        post :create, address_type: "billing"
        expect(response).to redirect_to settings_path
      end 
    end 

    context "with invalid attributes" do
      before do 
        Address.any_instance.stub(:save).and_return false 
        controller.stub(:render_settings_with_errors)
        controller.stub(:render)
      end 

      it "calls #render_settings_with_errors" do 
        expect(controller).to receive(:render_settings_with_errors)
        post :create
      end
    end 
  end

  describe "#set_customer_address_id(address_type, address_id)" do
    before do 
      controller.stub(:current_customer).and_return customer
      customer.stub(:update)
    end 

    it "receives update for current customer with billing address id" do 
      expect(customer).to receive(:update).with("billing_address_id" => address.id)
      controller.send(:set_customer_address_id, "billing", address.id)
    end 

    it "receives update for current customer with shipping address id if passed address type == 'billing' and customer hasn't shipping address" do 
      expect(customer).to receive(:update).with(shipping_address_id: address.id)
      controller.send(:set_customer_address_id, "billing", address.id)
    end

    it "not receives update for current customer with shipping address id if passed address type not 'billing'" do 
      expect(customer).not_to receive(:update).with(shipping_address_id: address.id)
      controller.send(:set_customer_address_id, "shipping", address.id)
    end

    it "not receives update for current customer with shipping address id if passed address type == 'billing' but customer has shipping address" do 
      customer.shipping_address = address
      customer.save
      expect(customer).not_to receive(:update).with(shipping_address_id: address.id)
      controller.send(:set_customer_address_id, "billing", address.id)
    end
  end

  describe "#render_settings_with_errors" do
    before do
      controller.stub(:fetch_data_for_settings_page)
      controller.stub(:reassign_address)
      controller.stub(:render)
    end  

    it "calls fetch_data_for_settings_page" do 
      expect(controller).to receive(:fetch_data_for_settings_page)
      controller.send(:render_settings_with_errors)
    end 

    it "calls reassign_address" do 
      expect(controller).to receive(:reassign_address)
      controller.send(:render_settings_with_errors)
    end

    it "sens error flash message" do 
      controller.send(:render_settings_with_errors)
      expect(flash[:error]).to eq "You've got some errors. Check it below."
    end

    it "renders 'customers/settings' tamplate" do 
      expect(controller).to receive(:render).with("customers/settings")
      controller.send(:render_settings_with_errors)
    end
  end

  describe "#reassign_address" do
    before { controller.instance_variable_set(:@address, address)  }
    
    it "assigns @billing_address if address type in params == billing" do
      controller.params[:address_type] = "billing"
      controller.send(:reassign_address)
      expect(assigns(:billing_address)).to eq address 
    end 

    it "assigns @billing_address if address type in params == shipping" do
      controller.params[:address_type] = "shipping"
      controller.send(:reassign_address)
      expect(assigns(:shipping_address)).to eq address 
    end 
  end
end
