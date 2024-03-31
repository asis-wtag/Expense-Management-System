FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: rand(1..30)) }
    email { Faker::Lorem.characters(number: rand(1..20)) + '@mail.com' }
    password_digest { BCrypt::Password.create('password123') }
  end
end
