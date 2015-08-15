require 'features/features_spec_helper'
 
feature "Customers registration" do
  scenario "Customers registers successfully via register form" do
    visit new_customer_registration_path
    within '#new_customer' do
      fill_in 'First name', with: Faker::Name.first_name
      fill_in 'Last name', with: Faker::Name.last_name
      fill_in 'Email', with: Faker::Internet.email
      fill_in 'customer_password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button('Sign up')
    end
    expect(page).not_to have_content 'Sign up'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario "Customers trying to register without filling any field in register form" do
    visit new_customer_registration_path
    within '#new_customer' do
      click_button('Sign up')
    end
    expect(page).not_to have_content 'Sign out'
    expect(page).to have_content 'Sign up'
    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
    expect(page).to have_content "Firstname can't be blank"
    expect(page).to have_content "Lastname can't be blank"
    expect(page).to have_content "Encrypted password can't be blank"
  end
end