FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence(word_count: 5) }
    association :user, factory: :user
    association :organization, factory: :organization
  end
end
