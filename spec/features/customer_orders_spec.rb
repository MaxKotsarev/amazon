require 'features/features_spec_helper'

feature "Customer orders page" do
  given(:customer) { FactoryGirl.create(:customer) }
  given(:book) { FactoryGirl.create(:book) }
  given(:address) { FactoryGirl.create(:address) }
  given(:delivery_type) { FactoryGirl.create(:delivery_type) }
  given(:credit_card) { FactoryGirl.create(:credit_card) }

  given(:order) { FactoryGirl.create(:order, customer: customer) }
  
  before do 
    login_as(customer, scope: :customer)
    order.add_to_order(book, 1)
  end

  scenario "customer can see his/her current order and it's order items" do 
    visit orders_path
    expect(page).to have_content 'In progress'
    expect(page).to have_content book.title 
    expect(page).to have_content book.price 
    expect(page).to have_link("Go to cart", new_order_path) 
  end

  context "customer can see the history of his/her completed orders devided by status:" do 
    before do 
      order.complete
    end 
    
    scenario "completed orders" do
      visit orders_path
      expect(page).to have_content 'Waiting for processing'
      expect(page).to have_content order.id 
      expect(page).to have_content order.total_price 
      expect(page).to have_content order.completed_date.strftime("%Y-%m-%d")
      expect(page).to have_link("view", order_path(order))
    end

    scenario "orders in delivery" do
      order.update(state: Order::POSSIBLE_STATES[2])
      visit orders_path
      expect(page).to have_content 'In delivery'
    end

    scenario "delivered orders" do
      order.update(state: Order::POSSIBLE_STATES[3])
      visit orders_path
      expect(page).to have_content 'Delivered'
    end
  end

  scenario "customer can visit order page with detaled info", js: true do 
    order.complete
    order.update(delivery_type: delivery_type, shipping_address: address, billing_address: address, credit_card: credit_card)
    visit orders_path
    click_link("view")
    expect(page).to have_content order.id 
    expect(page).to have_content order.total_price
    expect(page).to have_content book.title 
    expect(page).to have_content book.price 
    expect(page).to have_content order.shipping_address.address 
    expect(page).to have_content order.billing_address.address 
    expect(page).to have_content order.delivery_type.title 
    expect(page).to have_content order.credit_card.exp_month 
  end
end