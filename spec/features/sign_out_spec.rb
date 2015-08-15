require 'features/features_spec_helper'
 
feature "Customers sing out" do
  scenario "click 'sign out' link" do
    customer = FactoryGirl.create(:customer)
    login_as(customer, scope: :customer)
    visit root_path
    
    click_link('Sign out')

    expect(page).not_to have_content 'Sign out'
    expect(page).to have_content 'Sign up'
    expect(page).to have_content 'Log in'
    expect(page).to have_content 'Signed out successfully.'
  end
end