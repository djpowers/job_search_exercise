# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# create admin user
User.create(
  email: 'admin@mail.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)

# create standard user
User.create(
  email: 'member@mail.com',
  password: 'password',
  password_confirmation: 'password',
  admin: false
)
