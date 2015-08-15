require 'features/features_spec_helper'
 
feature "Customers signs in" do
  given!(:customer) { FactoryGirl.create(:customer, password: "12345678") }

  scenario 'with valid credentials' do
    visit new_customer_session_path
    fill_in 'Email', with: customer.email
    fill_in 'Password', with: "12345678"
    click_button 'Log in'

    expect(page).not_to have_content 'Sign up'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'with wrong password' do
    visit new_customer_session_path
    fill_in 'Email', with: customer.email
    fill_in 'Password', with: "123"
    click_button 'Log in'

    expect(page).to have_content 'Sign up'
    expect(page).to have_content 'Invalid email or password.'
  end

  scenario 'with incorrect email' do
    visit new_customer_session_path
    fill_in 'Email', with: "wrong@email.com"
    fill_in 'Password', with: "12345678"
    click_button 'Log in'

    expect(page).to have_content 'Sign up'
    expect(page).to have_content 'Invalid email or password.'
  end

  scenario 'with empty sign in form' do
    visit new_customer_session_path
    click_button 'Log in'

    expect(page).to have_content 'Sign up'
    expect(page).to have_content 'Invalid email or password.'
  end
end