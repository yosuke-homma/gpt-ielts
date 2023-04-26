FactoryBot.define do
  factory :user do
    name { 'Test User' }
    email { 'testuser@email.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
