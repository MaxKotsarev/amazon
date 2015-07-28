FactoryGirl.define do
  factory :book do
    title       {Faker::Lorem.sentence}
    description {Faker::Lorem.paragraph}
    price       {(rand*rand(1..10)).round(2)}
	image 		nil#{ Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'book_image_example.jpg')) }    
	author      nil
    amount 		{rand(1..100)}
    category    nil   
  end
end
