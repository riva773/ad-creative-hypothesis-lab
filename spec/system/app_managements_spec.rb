require 'rails_helper'

RSpec.describe "AppManagements", type: :system do
  let(:user) { create(:user) }
  def sign_in_as(user)
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
  end

    it "ログイン済みユーザーがモーダルからアプリを登録できる" do
      sign_in_as(user)
      click_button "アプリを登録"

      expect(page).to have_content("アプリを追加")
      fill_in "アプリ名", with: "テスト用ゲーム"
      fill_in "アプリ名", with: "テスト用ゲーム"
      fill_in "キャンペーン名", with: "test_campaign"
      fill_in "アプリ説明文", with: "system specで作成したアプリです"
      click_button "アプリを追加"

      expect(page).to have_current_path(apps_path)
      expect(page).to have_content("アプリを作成しました。")
      expect(page).to have_content("テスト用ゲーム")
    end
end
