require 'features/features_spec_helper'

feature "Customer settings: personal info." do
  given(:customer) { FactoryGirl.create(:customer) }
  
  before do 
    login_as(customer, scope: :customer)
    visit settings_path
  end

  scenario "customer successfully update firstname, lastname and email via form", js: true do 
    within ".personal-info-form" do 
      fill_in "First name", with: Faker::Name.first_name
      fill_in "Last name", with: Faker::Name.last_name
      fill_in "Email", with:  Faker::Internet.email
      click_button('Save')
    end
    expect(page).to have_content 'Your data was successfully updated.'
  end

  scenario "customer tries to save personal info form with blank fields", js: true do 
    within ".personal-info-form" do  
      fill_in "First name", with: ""
      fill_in "Last name", with: ""
      fill_in "Email", with: ""
      click_button('Save')
    end
    expect(page).to have_content "You've got some errors. Check it below."
    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Firstname can't be blank"
    expect(page).to have_content "Lastname can't be blank"
  end

  scenario "customer tries to save personal info form with incorrect email", js: true do 
    within ".personal-info-form" do 
      fill_in "Email", with: "email" 
      click_button('Save')
    end
    expect(page).to have_content "You've got some errors. Check it below."
  end
end