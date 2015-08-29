require 'features/features_spec_helper'

feature "Customer settings: delete account." do
  given(:customer) { FactoryGirl.create(:customer) }
  
  before do 
    login_as(customer, scope: :customer)
    visit settings_path
  end

  scenario "customer successfully removes his/her account", js: true do 
    accept_confirm do
      click_link('Please remove my account')
    end
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

