require 'rails_helper'

RSpec.describe "Apps", type: :request do
  describe "GET /" do
    context "未ログインの場合" do
      it "ログイン画面にリダイレクト" do
        get root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みの場合" do
      let(:user) { create(:user) }
      before do
        sign_in user
      end

      it "200を返す" do
        get root_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /apps/:id" do
    context "未ログインの場合" do
      let(:target_app) { create(:app) }

      it "ログイン画面にリダイレクト" do
        get app_path(target_app)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みの場合" do
      let(:user) { create(:user) }
      let(:target_app) { create(:app, user: user) }

      it "アプリ詳細画面を表示する" do
        sign_in user
        get app_path(target_app)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /apps" do
    context "未ログインの場合" do
      let(:user) { create(:user) }

      it "ログイン画面にリダイレクト" do
        post apps_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みで、入力値が正しい場合" do
      let(:user) { create(:user) }
      before do
        sign_in user
      end
      let(:valid_params) do
        {
          app: {
            name: "テストアプリ",
            campaign_name: "test_campaign",
            explanation: "アプリの説明"
          }
        }
      end

      it "アプリを作成してアプリ一覧画面にリダイレクト" do
        expect {
          post apps_path,
          params: valid_params
        }.to change(App, :count).by(1)
      end
    end

    context "ログイン済みで、入力値が正しくない場合" do
      let(:target_app) { create(:app, user: user) }
      let(:user) { create(:user) }
      before do
        sign_in user
      end
      let(:invalid_params) do
        {
          app: {
            name: "",
            campaign_name: "",
            explanation: ""
          }
        }
      end

      it "アプリを作成せずアプリ一覧画面を再表示" do
        expect {
          post apps_path,
          params: invalid_params
      }.not_to change(App, :count)

      expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /apps/:id/edit" do
    let(:target_app) { create(:app) }

    context "未ログインの場合" do
      it "ログイン画面にリダイレクト" do
        get edit_app_path(target_app)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みの場合" do
      let(:target_app) { create(:app, user: user) }
      let(:user) { create(:user) }
      before do
        sign_in user
      end

      it "アプリ編集画面を表示する" do
        get edit_app_path(target_app)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PATCH /apps/:id" do
    context "未ログインの場合" do
      let(:target_app) { create(:app) }

      it "ログイン画面にリダイレクト" do
        patch app_path(target_app)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みで、入力値が正しい場合" do
      let(:target_app) { create(:app, user: user) }
      let(:user) { create(:user) }
      before do
        sign_in user
      end
      let(:valid_params) do
        {
          app: {
            name: "更新済みアプリ"
          }
        }
      end

      it "アプリを更新してアプリ一覧画面にリダイレクト" do
        old_name = target_app.name
        expect {
          patch app_path(target_app),
          params: valid_params
      }.to change { target_app.reload.name }.from(old_name).to("更新済みアプリ")

      expect(response).to redirect_to(apps_path)
      end
    end

    context "ログイン済みで、入力値が正しくない場合" do
      let(:target_app) { create(:app, user: user) }
      let(:user) { create(:user) }
      before do
        sign_in user
      end
      let(:invalid_params) do
        {
          app: {
            name: ""
          }
        }
      end
      it "アプリを更新せず編集画面を再表示" do
        old_name = target_app.name
        expect {
          patch app_path(target_app),
          params: invalid_params
      }.not_to change { target_app.reload.name }

      expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /apps/:id" do
    context "未ログインの場合" do
    let(:target_app) { create(:app) }

      it "ログイン画面にリダイレクト" do
        delete app_path(target_app)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みの場合" do
      let!(:target_app) { create(:app, user: user) }
      let(:user) { create(:user) }
      before do
        sign_in user
      end

      it "アプリを削除してアプリ一覧画面にリダイレクト" do
        expect {
          delete app_path(target_app)
      }.to change(App, :count).by(-1)

        expect(response).to redirect_to(apps_path)
      end
    end
  end
end
