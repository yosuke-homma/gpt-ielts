50.times do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password'
  )
end

User.all.find_each do |user|
  user.exams.create!(
    question: Faker::Lorem.sentence,
    answer: Faker::Lorem.sentence,
    review: Faker::Lorem.sentence
  )
end
