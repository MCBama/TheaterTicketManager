# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(account_level: "SysAdmin", username: "SysAdmin", email:"admin@admin.net", password: "123456", password_confirmation: "123456")

theater = Theater.create!(name: "Playhouse")
theater.set_theater_to_playhouse

theater = Theater.create!(name: "Concert Hall")
theater.set_theater_to_concert_hall