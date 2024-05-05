FactoryBot.define do
  factory :user_organization do
    association :user, factory: :user
    association :organization, factory: :organization
    invitation { %w[pending accepted rejected].sample }
    role { %w[admin non-admin].sample }
  end
end
