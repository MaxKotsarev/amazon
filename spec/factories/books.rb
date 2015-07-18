FactoryGirl.define do
  factory :book do
    title        {Faker::Lorem.sentence}
    description  {Faker::Lorem.paragraph}
    price        {(rand*rand(1..10)).round(2)}
    image		 {Faker::Lorem.sentence}
    author       nil
    amount 		 {rand(1..100)}
    category     nil   
  end
end
