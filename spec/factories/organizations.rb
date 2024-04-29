FactoryBot.define do
  factory :organization do
    name { Faker::Company.name[0, 29] }
  end
end
