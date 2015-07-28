FactoryGirl.define do
  factory :address do
  	address {Faker::Address.street_address}
    zipcode {Faker::Address.zip_code}
    city {Faker::Address.city}
    phone {Faker::PhoneNumber.phone_number}
    country
    firstname {Faker::Name.first_name}
	lastname {Faker::Name.last_name}
  end
end