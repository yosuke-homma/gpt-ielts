FactoryBot.define do
  factory :user do
    name { 'Test User' }
    sequence(:email) { |n| "testuser#{n}@email.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
