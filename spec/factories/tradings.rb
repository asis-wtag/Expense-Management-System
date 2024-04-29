FactoryBot.define do
  factory :trading do
    amount { Faker::Number.decimal(l_digits: 2) }
    association :user, factory: :user
    association :organization, factory: :organization
  end
end
