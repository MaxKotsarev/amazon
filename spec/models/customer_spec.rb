require 'rails_helper'

describe Customer do
  subject { FactoryGirl.create :customer }

  it { expect(subject).to validate_presence_of(:email) }
  it { expect(subject).to validate_presence_of(:encrypted_password) }
  it { expect(subject).to validate_presence_of(:firstname) }
  it { expect(subject).to validate_presence_of(:lastname) }

  it { expect(subject).to have_many(:ratings) }
  it { expect(subject).to have_many(:orders) }
  it { expect(subject).to belong_to(:billing_address) }
  it { expect(subject).to belong_to(:shipping_address) }

  it "is invalid with not correct email" do
    expect(FactoryGirl.build :customer, email: "myemail").not_to be_valid
  end

  describe "#create_new_order" do 
    before {@order = subject.create_new_order}
    it "creates new order" do 
      expect(@order.class).to eq Order
    end
    it "creates new order which belongs to this customer" do
      expect(@order.customer).to eq subject
    end
  end

  describe "#current_order" do 
    before {@customer = FactoryGirl.create :customer}
    it "returns last current order in progress" do
      order =  FactoryGirl.create(:order, customer: @customer, state: "in progress")
      expect(@customer.current_order).to eq order
    end
    it "doesn't return orders with state not 'in progress'" do 
      order =  FactoryGirl.create(:order, customer: @customer, state: "completed")
      expect(@customer.current_order).to eq nil
    end
  end
end