FactoryGirl.define do
  factory :order_item do
    price {(rand*rand(1..10)).round(2)}
    quantity {rand(1..100)}
    order
    book
  end
end