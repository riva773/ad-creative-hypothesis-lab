require 'rails_helper'

RSpec.describe "Authentications", type: :system do
  let(:user) { create(:user) }
  it "登録済みユーザーがログインできる" do
    visit new_user_session_path

    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    expect(page).to have_current_path(apps_path)
    expect(page).to have_content("アプリ選択")
    expect(page).to have_content("ログアウト")
  end

  it "未登録ユーザーが会員登録後にアプリ一覧へ移動できる" do
    visit root_path
    click_link "会員登録"

    fill_in "ユーザー名", with: "新規ユーザー"
    fill_in "メールアドレス", with: "new-user-#{SecureRandom.hex(8)}@example.com"
    fill_in "パスワード", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_button "会員登録する"

    expect(page).to have_current_path(apps_path)
    expect(page).to have_content("アプリ選択")
  end
end
