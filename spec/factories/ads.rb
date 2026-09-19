FactoryBot.define do
  factory :ad do
    association :user
    app { association(:app, user: user) }
    hypothesis { association(:hypothesis, user: user, app: app) }

    file_name { "#{app.campaign_name}_001.mp4" }

    after(:build) do |ad|
      ad.creative.attach(
        io: StringIO.new("test video"),
        filename: ad.file_name,
        content_type: "video/mp4"
      )
    end
  end
end
