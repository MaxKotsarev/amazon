require 'features/features_spec_helper'
 
feature "Book ratings" do
  given(:book) { FactoryGirl.create(:book) }
  given(:customer) { FactoryGirl.create(:customer) }

  context "Guest user" do 
    scenario "Loged in user tries to add review and get redirected to the login-page" do  
      visit new_book_rating_path(book)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(page).to have_content 'Log in'
    end
  end

  context "Loged in user" do
    before do 
      login_as(customer, scope: :customer)
      visit new_book_rating_path(book)
    end

    scenario "successfully adds review via form" do
      within '#new_rating' do
        choose('rating_rating_number_2')
        fill_in 'Text:', with: Faker::Lorem.sentence
        click_button('Add review')
      end
      expect(page).to have_content 'Thank you for review! It will appear on this page after moderation.'
    end

    scenario "tries to add review without filling form and gets errors" do
      within '#new_rating' do
        click_button('Add review')
      end
      expect(page).to have_content 'rating is required'
      expect(page).to have_content 'text review is required'
    end

    scenario "clicks 'cencel' link under review form and get redirected to book-page" do
      within '#new_rating' do
        click_link('Cencel')
      end
      expect(page.current_path).to eq book_path(book)
    end
  end
end
