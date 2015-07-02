FactoryGirl.define do
  factory :order do
    total_price {(rand*rand(1..10)).round(2)}
    completed_date {Faker::Date.forward(23)}
    state "in progress"
    customer_id nil
    credit_card_id nil
    billing_address_id nil
    shipping_address_id nil
  end
end