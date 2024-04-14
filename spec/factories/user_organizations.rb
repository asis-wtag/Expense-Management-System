FactoryBot.define do
  factory :user_organization do
    association :user
    association :organization
    invitation { %w[pending accepted rejected].sample }
    role { %w[admin non-admin].sample }
  end
end
