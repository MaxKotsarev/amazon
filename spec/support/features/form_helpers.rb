module Features
  module FormHelpers
    def fill_address_form(form_selector)
      within form_selector do
        fill_in 'First name', with: Faker::Name.first_name
        fill_in 'Last name', with: Faker::Name.last_name
        fill_in 'Sreet address', with: Faker::Address.street_address
        fill_in 'City', with: Faker::Name.last_name
        select(@countries[1].name, from: 'Country')
        fill_in 'Zip', with: Faker::Address.zip
        fill_in 'Phone', with: Faker::PhoneNumber.phone_number
        click_button('Save')
      end
    end
  end
end 