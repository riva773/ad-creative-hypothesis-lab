
user = User.find_by(email: "user1@example.com")

app = App.create!(
  name: "サンプルアプリ",
  explanation: "サンプルアプリ",
  user_id: "#{user.id}"
)

hypothesis = Hypothesis.create!(
  content: "仮説サンプル",
  user_id: "#{user.id}",
  app_id: "#{app.id}"
)

ad = Ad.create!(
  app_id: "#{app.id}",
  hypothesis_id: "#{hypothesis.id}",
  user_id: "#{user.id}",
  file_name: "サンプルファイル名"
)

10.times do|i|
  AdTest.create!(
    ad_id: "#{ad.id}",
    network: "Meta",
    cpi: 120,
    ctr: 2.3,
    cvr: 40.2,
    cpm: 1020,
    impression: 3000,
    budget: 5000,
    amount_spent: 3200,
    status: "結果取り込み済み",
    test_start_date: Date.new(2026,6,2),
    test_end_date: Date.new(2026,6,4)
  )
end
