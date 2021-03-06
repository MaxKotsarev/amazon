# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

["Ukraine", "USA", "Uganda", "Argentina", "Jamaica"].each do |name|
  Country.find_or_create_by(name: name)
end

# create first admin user
Admin.delete_all
Admin.create(email: "admin@gmail.com", password: "password")

DeliveryType.delete_all
DeliveryType.create(title: "Take from our office", price: 0)
DeliveryType.create(title: "UPS two day", price: 10)
DeliveryType.create(title: "UPS one day", price: 20)
 