3.times do |i|
  User.create!(
    name: "ユーザー#{i+1}",
    email: "user#{i+1}@example.com",
    role: "user",
    password: "password",
    password_confirmation: "password",
  )
end

user = User.find_by(email: "user1@example.com")

10.times do |i|
  App.create!(
    name: "アプリ#{i+1}",
    explanation: "アプリ#{i+1}の詳細テキストです。",
    user_id: "#{user.id}",
  )
end
