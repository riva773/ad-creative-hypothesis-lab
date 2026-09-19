FactoryBot.define do
  factory :app do
    association :user
    sequence(:name) { |n| "サンプルアプリ#{n}"}
    sequence(:campaign_name) { |n| "campaign#{n}"}
    sequence(:explanation) {|n| "アプリ説明#{n}"}


  end
end
