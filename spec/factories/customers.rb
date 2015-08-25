FactoryGirl.define do
  factory :customer do
    firstname {Faker::Name.first_name}
    lastname {Faker::Name.last_name}
    email {Faker::Internet.email}
    password {Faker::Internet.password}
    billing_address_id nil
    shipping_address_id nil
  end
end