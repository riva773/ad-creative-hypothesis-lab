user = User.create!(
  name: "user",
  email: "user1@example.com",
  password: "password",
  password_confirmation: "password",
)

app = App.create!(
  name: "サンプルアプリ",
  explanation: "サンプルアプリ",
  user_id: "#{user.id}",
  campaign_name: "sample"
)

10.times do |i|
  Hypothesis.create!(
    content: "仮説#{i + 1}",
    user_id: "#{user.id}",
    app_id: "#{app.id}"
  )
end
