require 'rails_helper'

describe Order do
  subject { FactoryGirl.create :order }

  it { expect(subject).to validate_presence_of(:total_price) }
  it { expect(subject).to validate_inclusion_of(:state).in_array(['in progress','completed','shipped']) }
  context "if order not completed" do
    it { expect(subject).not_to validate_presence_of(:completed_date) }
  end
  context "if order completed" do
    subject { FactoryGirl.create(:order, state: 'completed') } 
    it { expect(subject).to validate_presence_of(:completed_date) }
  end
  context ".in_progress" do
    before do
      @comleted_orders = FactoryGirl.create_list(:order, 3, state: 'completed')
      @orders_in_progress = FactoryGirl.create_list(:order, 3, state: 'in progress')
    end
  
    it "returns list of orders in progress" do
      expect(Order.in_progress).to match_array(@orders_in_progress)
    end
  
    it "doesn't return orders whith not 'in progress' state" do
      expect(Order.in_progress).not_to match_array(@comleted_orders)
    end
  end

  it { expect(subject).to have_many(:order_items) }
  it { expect(subject).to belong_to(:customer) }
  it { expect(subject).to belong_to(:credit_card) }
  it { expect(subject).to belong_to(:billing_address) }
  it { expect(subject).to belong_to(:shipping_address) }

  it "should have default state 'in progress' after initialization" do
  	expect(Order.new.state).to eq "in progress"
  end

  describe "#add_to_order(book, quantity=1)" do 
    before do
      @book = FactoryGirl.create :book
      @order = FactoryGirl.create :order
      @order2 = FactoryGirl.create :order
      @order.add_to_order(@book)
    end
    context "if order hasn't such book (order item)" do   
      it "should create new order_item which belongs to this order" do 
        expect(@order.order_items.last.order_id).to eq @order.id
      end
      it ".. and belongs to book passed in first argument" do 
        expect(@order.order_items.last.book_id).to eq @book.id
      end
      context "if method called whithout second argument" do
        it "should create new order_item with quantity 1 (default value)" do 
          expect(@order.order_items.last.quantity).to eq 1
        end
      end
      context "if method called whith second argument" do
        it "should create new order_item with quantity passed in second argument" do 
          @order2.add_to_order(@book, 2)
          expect(@order2.order_items.last.quantity).to eq 2
        end
      end
    end 
    context "if order already has such book (order item)" do 
      context "if method called whithout second argument" do
        it "should increment quantity of this book (order item) by 1 (default value)" do 
          @order.add_to_order(@book)
          expect(OrderItem.last.quantity).to eq 2
        end
      end
      context "if method called whith second argument" do
        it "should increment quantity of this book (order item) by number in second argument" do
          @order.add_to_order(@book, 2)
          expect(OrderItem.last.quantity).to eq 3
        end
      end
    end 
  end

  describe "#calc_and_set_total_price" do
    context "if order have some order items" do  
      it "calculate and set total price before save" do
        FactoryGirl.create(:order_item, price: 5.15, quantity: 2, order: subject) 
        FactoryGirl.create(:order_item, price: 10.5, quantity: 1, order: subject) 
        subject.save
        expect(subject.total_price).to eq 20.8
      end
    end
    context "if order have no order items" do  
      it "set/reset total price to 0" do 
        subject.total_price = 10
        subject.save
        expect(subject.total_price).to eq 0
      end
    end
  end
end