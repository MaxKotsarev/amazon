require 'features/features_spec_helper'
require "support/features/form_helpers.rb"

feature "Order checkout" do
  include Features::FormHelpers

  given(:customer) { FactoryGirl.create(:customer, password: "12345678") }
  given(:book) { FactoryGirl.create(:book) }
  given(:billing_address) { FactoryGirl.create(:address) }
  given(:shipping_address) { FactoryGirl.create(:address) }
  given(:delivery_type) { FactoryGirl.create(:delivery_type) }
  given(:credit_card) { FactoryGirl.create(:credit_card) }

  before {@countries = FactoryGirl.create_list(:country, 3)}

  context "loged in customer" do 
    before {login_as(customer, scope: :customer)}

    context "on first checkout step: adresses" do
      before do 
        add_book_and_go_to_checkout(book)
      end 
      context "tries to submit form with blank fields" do
        scenario "with checked 'use billing as shipping' checkbox" do         
          click_button('Save and continue')
          billing_address_errors.each do |error_text|
            expect(page).to have_content error_text
          end
        end

        scenario "with unchecked 'use billing as shipping' checkbox" do 
          uncheck('checkout_address_form_use_billing_as_shipping')
          click_button('Save and continue')
          (billing_address_errors + shipping_address_errors).each do |error_text|
            expect(page).to have_content error_text
          end
        end
      end

      scenario "successfully fills all addresses fields and goes to next step" do 
        fill_addresses_in_checkout
        expect(page).to have_content "Delivery type"
      end  

      scenario "successfully fills all addresses fields (with unchecked 'use bill as ship') and goes to next step" do 
        uncheck('checkout_address_form_use_billing_as_shipping')
        fill_addresses_in_checkout
        expect(page).to have_content "Delivery type"
      end  

      describe "adresses assigns to order and customer" do
        context "order and customer don't have bill and ship adresses" do
          scenario "'use bill as ship' checked)" do 
            fill_addresses_in_checkout
            [Order.first, Customer.find(customer.id)].each do |order_or_customer|
              expect(order_or_customer.billing_address).not_to be_nil
              expect(order_or_customer.shipping_address).not_to be_nil
              expect(order_or_customer.shipping_address).to eq order_or_customer.billing_address
            end
          end

          scenario "'use bill as ship' unchecked" do 
            uncheck('checkout_address_form_use_billing_as_shipping')
            fill_addresses_in_checkout
            [Order.first, Customer.find(customer.id)].each do |order_or_customer|
              expect(order_or_customer.billing_address).not_to be_nil
              expect(order_or_customer.shipping_address).not_to be_nil
              expect(order_or_customer.shipping_address).not_to eq order_or_customer.billing_address
            end
          end
        end

        context "order and customer have bill and ship adresses and user can update it" do
          before do 
            [Order.first, Customer.find(customer.id)].each do |order_or_customer| 
              order_or_customer.update(billing_address: billing_address, shipping_address: shipping_address)
            end
            visit checkout_address_orders_path
          end
          scenario "'use bill as ship' unchecked" do     
            fill_in "checkout_address_form_b_firstname", with: "Ivan"
            fill_in "checkout_address_form_s_firstname", with: "Petr"
            click_button('Save and continue')
            expect(page).to have_content "Delivery type"
            [Order.first, Customer.find(customer.id)].each do |order_or_customer|
              expect(order_or_customer.billing_address.firstname).to eq "Ivan"
              expect(order_or_customer.shipping_address.firstname).to eq "Petr"
            end
          end
          scenario "'use bill as ship' checked" do   
            check('checkout_address_form_use_billing_as_shipping')  
            fill_in "checkout_address_form_b_firstname", with: "Ivan"
            click_button('Save and continue')
            expect(page).to have_content "Delivery type"
            [Order.first, Customer.find(customer.id)].each do |order_or_customer|
              expect(order_or_customer.billing_address.firstname).to eq "Ivan"
              expect(order_or_customer.shipping_address.firstname).to eq "Ivan"
              expect(order_or_customer.shipping_address).to eq order_or_customer.billing_address
              expect(Address.all.size).to eq 1
            end
          end
        end
      end
    end

    context "on second checkout step: delivery" do
      scenario "choose delivery type" do  
        add_book_and_go_to_checkout(book)
        fill_addresses_in_checkout
        fill_delivery_in_checkout
        expect(page).to have_content "Credit card"
        expect(Order.first.delivery_type).not_to be_nil
      end
    end 

    context "on third checkout step: payment" do
      scenario "succesfully fill in credit-card form" do  
        add_book_and_go_to_checkout(book)
        fill_addresses_in_checkout
        fill_delivery_in_checkout
        fill_credit_card_in_checkout
        expect(page).to have_content "Confirm"
        expect(Order.first.credit_card).not_to be_nil
      end

      scenario "tries to fill in credit-card form with blank fields" do  
        add_book_and_go_to_checkout(book)
        fill_addresses_in_checkout
        fill_delivery_in_checkout
        fill_in 'First name', with: ""
        fill_in 'Last name', with: ""
        click_button('Save and continue')
        expect(page).to have_content "Number can't be blank"
        expect(page).to have_content "Exp month can't be blank"
        expect(page).to have_content "Exp year can't be blank"
        expect(page).to have_content "Lastname can't be blank"
        expect(page).to have_content "Firstname can't be blank"
        expect(page).to have_content "Exp year is invalid"
        expect(page).to have_content "Exp month is not included in the list"
        expect(page).to have_content "Cvv is invalid"
        expect(page).to have_content "Cvv can't be blank"
      end
    end 

    context "on last checkout step: confirm" do
      scenario "succesfully place order" do  
        add_book_and_go_to_checkout(book)
        fill_addresses_in_checkout
        fill_delivery_in_checkout
        fill_credit_card_in_checkout
        click_link('Place order')
        expect(page).to have_content "Congrats! Your order ##{Order.first.id} was successfully placed."
        expect(Order.first.state).to eq Order::POSSIBLE_STATES[1]
      end

      scenario "previous steps not finishid" do
        add_book_and_go_to_checkout(book)
        visit checkout_confirm_orders_path
        expect(page).to have_content "Please, complete all previous steps."
      end
    end
  end

  context "guest user" do
    scenario "succesfully place order" do  
      add_book_and_go_to_checkout(book)
      fill_addresses_in_checkout
      fill_delivery_in_checkout
      fill_credit_card_in_checkout
      click_link('Place order')
      expect(page).to have_content "Congrats! Your order ##{Order.first.id} was successfully placed."
      expect(Order.first.state).to eq Order::POSSIBLE_STATES[1]
    end

    scenario "current order assigns to customer after sign in" do 
      add_book_and_go_to_checkout(book)
      visit new_customer_session_path
      fill_in 'Email', with: customer.email
      fill_in 'Password', with: "12345678"
      click_button 'Log in'
      expect(Order.first.customer_id).to eq customer.id
    end 
  end
end
=begin
feature "Checkout - Addresses" do
  1. scenario "Current Order has BA and SA"
     this BA and SA assigns to form object 
  scenario "Current Order hasn't BA and SA"
    2. scenario "Current Customer has BA and SA"
      this BA and SA assigns to form object 
      BA and SA creates and asigns to order 
      and to customer 
    3. scenario "Current Customer has only SA"
      this SA assigns to form object 
      BA and SA creates and asigns to order 
      and to customer 
    4. scenario "Current Customer hasn't BA and SA"
      from displays with blank fields
      BA and SA creates and asigns to order 
      and to customer 
    5. scenario "Customer not loged in"
      from displays with blank fields
      BA and SA creates and asigns to order
   
=end