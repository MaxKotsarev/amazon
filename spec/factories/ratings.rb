FactoryGirl.define do
  factory :rating do
    review {Faker::Lorem.paragraph}
    rating_number {rand(1..10)}
    book_id nil
    customer_id nil
  end
end
