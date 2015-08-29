require 'features/features_spec_helper'

feature "Customer settings: password." do
  given(:customer) { FactoryGirl.create(:customer) }
  
  before do 
    login_as(customer, scope: :customer)
    visit settings_path
  end

  scenario "customer successfully change password via form (with correct old and valid new passwords)" do 
    within ".password-form" do 
      fill_in "Old password", with: customer.password
      fill_in "New password", with: Faker::Internet.password
      click_button('Change password')
    end
    expect(page).to have_content 'Your password successfully changed.'
  end

  scenario "customer tries to change password via form with wrong old password)"  do 
    within ".password-form" do 
      fill_in "Old password", with: "#{customer.password}dsa"
      fill_in "New password", with: Faker::Internet.password
      click_button('Change password')
    end
    expect(page).to have_content "You entered wrong current password. Pls try again."
  end

  scenario "customer tries to change password via form with correct old password but invalid new password" do 
    within ".password-form" do 
      fill_in "Old password", with: customer.password
      fill_in "New password", with: "asd"
      click_button('Change password')
    end
    expect(page).to have_content "New password should have at least 8 characters. Pls try again."
  end
end

