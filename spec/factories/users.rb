FactoryBot.define do
  factory :user do
    sequence(:name)  { |n| "ユーザー#{n}" }
    sequence(:email) { |n| "sample_user#{n}@example.com" }
    password              { "password" }
  end
end
