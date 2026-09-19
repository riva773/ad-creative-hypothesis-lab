require "rails_helper"

RSpec.describe "Reviews", type: :system do
  let(:user) { create(:user) }
  let(:target_app) { create(:app, user: user) }
  def sign_in_as(user)
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    expect(page).to have_current_path(apps_path)
  end
  let!(:target_hypothesis) do
    create(
      :hypothesis,
      app: target_app,
      user: user,
      content: "更新前の仮説"
    )
  end
  let!(:target_ad) do
    create(
      :ad,
      user: user,
      app: target_app,
      hypothesis: target_hypothesis
    )
  end
  let!(:target_ad_test) do
    create(
      :ad_test,
      ad: target_ad,
      status: "結果取り込み済み",
      cpi: 100,
      ctr: 3.0,
      cvr: 30.0,
      impression: 10000,
      cpm: 1000,
      budget: 10000,
      amount_spent: 5000,
      test_start_date: Date.current - 7.days,
      test_end_date: Date.current,
      network: "Meta"
    )
  end
  before do
    sign_in_as(user)
  end

  it "結果取り込み済みのAdTestにユーザーが振り返りを作成できる" do
    visit app_path(target_app)
    find(
      "tr[data-controller='review']",
      text: target_ad_test.ad.file_name
    ).click
    expect(page).to have_css(
      '[data-review-target="modal"]',
      visible: true
    )
    fill_in "振り返り", with: "サンプル振り返りテキスト"
    click_button "振り返りを保存"
    expect(page).to have_current_path(app_path(target_app))
    expect(page).to have_content("振り返りを作成しました。")
  end
end
