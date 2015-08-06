FactoryGirl.define do
  factory :delivery_type do
    title       {Faker::Lorem.sentence}
    price       {(rand*rand(1..10)).round(2)}
  end
end
