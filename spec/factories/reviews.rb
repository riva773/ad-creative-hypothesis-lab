FactoryBot.define do
  factory :review do
    association :user
    association :ad_test
    content { "振り返り本文" }
  end
end
