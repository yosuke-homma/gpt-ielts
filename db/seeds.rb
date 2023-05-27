# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

50.times do |i|
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password",
    password_confirmation: "password"
  )
end

User.all.each do |user|
  user.exams.create!(
    question: Faker::Lorem.sentence,
    answer: Faker::Lorem.sentence,
    review: Faker::Lorem.sentence
  )
end
