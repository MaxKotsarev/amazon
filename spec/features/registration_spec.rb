require 'features/features_spec_helper'
 
feature "Registration" do
  scenario "Visitor registers successfully via register form" do
    visit new_user_registration_path
    within '#new_user' do
      fill_in 'Email', with: Faker::Internet.email
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button('Sign up')
    end
    expect(page).not_to have_content 'Sign up'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  xscenario "Visitor signs in" do
    visit root_path
    user = FactoryGirl.create(:user)
    sign_in(user, :scope => :user)

    expect(page).not_to have_content 'Sign up'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'Signed in successfully'
  end

  xscenario "Visitor signs out" do
    visit root_path
    user = FactoryGirl.create(:user)
    login_as(user)
    click_link('Sign out')

    expect(page).not_to have_content 'Sign out'
    expect(page).to have_content 'Sign up'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Signed out successfully.'
  end
end