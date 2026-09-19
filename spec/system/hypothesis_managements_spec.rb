require 'rails_helper'

RSpec.describe "HypothesisManagements", type: :system do
  let(:user) { create(:user) }
  let(:target_app) { create(:app, user: user) }
  def sign_in_as(user)
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    expect(page).to have_current_path(root_path)
  end
  let!(:target_hypothesis) do
    create(
      :hypothesis,
      app: target_app,
      user: user,
      content: "更新前の仮説"
    )
  end

  before do
    sign_in_as(user)
  end

  it "ログイン済みユーザーが仮説を作成できる" do
    visit app_path(target_app)
    click_button "+ 仮説を追加"
    expect(page).to have_css('[data-hypothesis-target="modal"]', visible: true)
    fill_in "仮説内容", with: "サンプル仮説"
    click_button "追加"
    expect(page).to have_current_path(app_path(target_app))
    expect(page).to have_content("仮説を作成しました。")
    click_button "仮説を管理"
    expect(page).to have_css(
  '[data-hypothesis-management-target="modal"] input[name="hypothesis[content]"][value="サンプル仮説"]',
  visible: true
)
  end

  it "広告と紐づいていない仮説をユーザーが更新できる" do
    visit app_path(target_app)
    click_button "仮説を管理"
    expect(page).to have_css(
      '[data-hypothesis-management-target="modal"]', visible: true
    )
    within("form[action='#{hypothesis_path(target_hypothesis)}']") do
      fill_in "hypothesis_content", with: "更新後の仮説"
      click_button "更新"
    end
    expect(page).to have_current_path(app_path(target_app))
    expect(page).to have_content("仮説を更新しました。")
    click_button "仮説を管理"
    expect(page).to have_css(
      '[data-hypothesis-management-target="modal"] input[name="hypothesis[content]"][value="更新後の仮説"]',
      visible: true
    )
  end
end
