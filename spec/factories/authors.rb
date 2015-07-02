FactoryGirl.define do
  factory :author do
	firstname {Faker::Name.first_name}
	lastname {Faker::Name.last_name}
	biography {Faker::Lorem.paragraphs}
  end
end