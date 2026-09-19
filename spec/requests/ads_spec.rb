require "rails_helper"

RSpec.describe "Ads", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:target_app) { create(:app, user: user) }
  let(:target_hypothesis) { create(:hypothesis, app: target_app, user: user) }
  let(:other_app) { create(:app, user: other_user) }
  let(:other_hypothesis) { create(:hypothesis, app: other_app, user: other_user) }

  describe "POST /ads" do
    context "未ログインの場合" do
      it "ログイン画面にリダイレクトする" do
        post ads_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みで、正しい動画と仮説を指定した場合" do
      before { sign_in user }
      let(:target_app) do
        create(:app, user: user, campaign_name: "test_campaign")
      end

      let(:creative) do
        Rack::Test::UploadedFile.new(
          StringIO.new("test video"),
          "video/mp4",
          true,
          original_filename: "#{target_app.campaign_name}_001.mp4"
        )
      end

      let!(:valid_params) do
        {
          ad: {
            app_id: target_app.id,
            creative: creative
          },
          hypothesis: target_hypothesis.id,
        }
      end

      it "広告とテスト結果待ちのAdTestを作成してアプリ詳細画面にリダイレクトする" do
        expect {
          post ads_path,
          params: valid_params
      }.to change(Ad, :count).by(1)
      .and change(AdTest, :count).by(1)

      expect(response).to redirect_to(app_path(target_app))
      end
    end

    context "ログイン済みで、動画ファイルが不正な場合" do
      before { sign_in user }
      let(:target_app) do
        create(:app, user: user, campaign_name: "test_campaign")
      end
      let(:creative) do
        Rack::Test::UploadedFile.new(
          StringIO.new("test video"),
          "video/mp4",
          true,
          original_filename: "dummy_001.mp4"
        )
      end

      let!(:invalid_params) do
        {
          ad: {
            app_id: target_app.id,
            creative: creative
          },
          hypothesis: target_hypothesis.id,
        }
      end

      it "広告もAdTestも作成せずアプリ詳細画面を再表示する" do

        expect {
          post ads_path,
          params: invalid_params
        }.to change(Ad, :count).by(0).and change(AdTest, :count).by(0)
      end
    end

    context "ログイン済みで、他ユーザーの仮説を指定した場合" do
      before { sign_in user }
      let(:target_app) do
        create(:app, user: user, campaign_name: "test_campaign")
      end
      let(:creative) do
        Rack::Test::UploadedFile.new(
          StringIO.new("test video"),
          "video/mp4",
          true,
          original_filename: "#{target_app.campaign_name}_001.mp4"
        )
      end
      let!(:other_params) do
        {
          ad: {
            app_id: target_app.id,
            creative: creative
          },
          hypothesis: other_hypothesis.id
        }
      end

      it "他ユーザーのリソースには広告を作成できない" do
        expect{
          post ads_path,
          params: other_params
        }.to change(AdTest, :count).by(0).and change(Ad, :count).by(0)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
