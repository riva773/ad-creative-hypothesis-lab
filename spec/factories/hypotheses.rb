FactoryBot.define do
  factory :hypothesis do
    association :user
    association :app
    sequence(:content) { |n| "仮説#{n}" }
  end
end
