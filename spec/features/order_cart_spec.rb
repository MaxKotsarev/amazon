require 'features/features_spec_helper'
require "support/features/form_helpers.rb"

feature "Order cart" do
  include Features::FormHelpers

  given(:customer) { FactoryGirl.create(:customer) }
  given(:book) { FactoryGirl.create(:book) }
  given(:book_2) { FactoryGirl.create(:book) }

  shared_examples "user_able_to_work_with_cart" do
    scenario "adds book to cart" do 
      add_to_cart(book)
      expect(page).to have_content 'Cart'
      expect(page).to have_content book.title
      expect(page).to have_content book.price
    end

    scenario "adds 2 book to cart and can see order total price" do 
      add_to_cart(book)
      add_to_cart(book_2)
      expect(page).to have_content book.price
      expect(page).to have_content book_2.price
      expect(page).to have_content "#{book.price + book_2.price}"
    end

    scenario "removes book from cart " do 
      add_to_cart(book_2)
      add_to_cart(book)
      first(".remove_link a").click
      expect(page).to have_content 'Cart'
      expect(page).to have_content book.title
      expect(page).not_to have_content book_2.title
    end

    scenario "empties cart", js: true do 
      add_to_cart(book)
      accept_confirm do 
        click_link("Empty cart")
      end
      expect(page).to have_content "Cart is empty now."
      expect(page.current_path).to eq books_path
    end

    scenario "clicks 'continue shipping' link and goes from cart back to shop" do 
      add_to_cart(book)
      click_link("Continue shopping")
      expect(page.current_path).to eq books_path
    end

    scenario "update cart" do
      add_to_cart(book)
      find("td input").set("2")
      click_button("Update")
      expect(page).to have_content "#{book.price * 2}"
    end
  end

  context "loged in customer" do
    before {login_as(customer, scope: :customer)}
    it_behaves_like "user_able_to_work_with_cart"
  end 

  context "guest user" do
    it_behaves_like "user_able_to_work_with_cart"
  end 
end