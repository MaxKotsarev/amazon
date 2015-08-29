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

    def add_to_cart(book)
      visit book_path(book) 
      click_button("ADD TO CART")
    end

    def add_book_and_go_to_checkout(book)
      add_to_cart(book)
      click_link("Checkout")
    end

    def fill_addresses_in_checkout
      within "#new_checkout_address_form" do 
        fill_address_fields_for("b")
        fill_address_fields_for("s") unless find("#checkout_address_form_use_billing_as_shipping").value == 1
        click_button('Save and continue')
      end
    end

    def fill_delivery_in_checkout 
      delivery_types = FactoryGirl.create_list(:delivery_type, 3)
      visit checkout_delivery_orders_path
      choose("delivery_type_#{delivery_types[1].id}")
      click_button('Save and continue')
    end

    def fill_credit_card_in_checkout
      within "#new_credit_card" do 
        fill_in 'First name', with: Faker::Name.first_name
        fill_in 'Last name', with: Faker::Name.last_name
        fill_in 'Card number', with: "1234567812345678"
        select((Date.today.year + 1), from: 'credit_card_exp_year')
        select("11", from: 'credit_card_exp_month')
        fill_in 'CVV-code', with: "112"
        click_button('Save and continue')
      end
    end

    def billing_address_errors
      ["Billing street address can't be blank",
        "Billing address zipcode can't be blank",
        "Billing address city can't be blank",
        "Billing address phone can't be blank",
        "Billing address last name can't be blank",
        "Billing address first name is required."]
    end

    def shipping_address_errors 
      ["Shipping street address can't be blank",
        "Shipping address zipcode can't be blank",
        "Shipping address city can't be blank",
        "Shipping address phone can't be blank",
        "Shipping address last name can't be blank",
        "Shipping address first name can't be blank"]
    end


    private 
    def fill_address_fields_for(bill_or_ship)
      fill_in field_id(bill_or_ship, 'firstname'), with: Faker::Name.last_name
      fill_in field_id(bill_or_ship, 'lastname'), with: Faker::Name.first_name
      fill_in field_id(bill_or_ship, 'address'), with: Faker::Address.street_address
      fill_in field_id(bill_or_ship, 'city'), with: Faker::Name.last_name
      select(@countries[1].name, from: field_id(bill_or_ship, 'country_id'))
      fill_in field_id(bill_or_ship, 'zipcode'), with: Faker::Address.zip
      fill_in field_id(bill_or_ship, 'phone'), with: Faker::PhoneNumber.phone_number
    end

    def field_id(address_type, field_name)
      "checkout_address_form_#{address_type+'_'+field_name}"
    end
  end
end 