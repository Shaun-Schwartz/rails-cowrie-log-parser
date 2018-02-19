# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create initial user
# PASSWORD = SecureRandom.hex(16)
PASSWORD = 'password'
EMAIL = 'something@example.com'

User.where(email: EMAIL).destroy_all

User.create(
  email: EMAIL,
  password: PASSWORD
)

puts "Created #{User.count} user with email address: #{EMAIL} and password: #{PASSWORD}"
