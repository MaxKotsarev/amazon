FactoryGirl.define do
  sequence(:name) { |n| "#{Faker::Address.country} #{n}" }
  
  factory :country do
    name  
  end
end