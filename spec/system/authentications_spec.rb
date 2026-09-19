require 'rails_helper'

RSpec.describe "Authentications", type: :system do
  let(:user) { create(:user) }
  it "登録済みユーザーがログインできる" do
    visit new_user_session_path

    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    expect(page).to have_current_path(root_path)
    expect(page).to have_content("アプリ選択")
    expect(page).to have_content("ログアウト")
  end
end
