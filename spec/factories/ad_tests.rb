FactoryBot.define do
  factory :ad_test do
    association :ad
    status { "テスト結果待ち" }
  end
end
