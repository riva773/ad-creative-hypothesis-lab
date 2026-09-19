require "rails_helper"
require "stringio"

RSpec.describe "AdTests", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:target_app) { create(:app, user: user) }
  let(:target_hypothesis) { create(:hypothesis, app: target_app, user: user) }
  let(:target_ad) { create(:ad, app: target_app, hypothesis: target_hypothesis, user: user) }
  let(:target_ad_test) { create(:ad_test, ad: target_ad) }
  let(:other_app) { create(:app, user: other_user) }
  let(:other_hypothesis) { create(:hypothesis, app: other_app, user: other_user) }
  let(:other_ad) { create(:ad, app: other_app, hypothesis: other_hypothesis, user: other_user) }
  let(:other_ad_test) { create(:ad_test, ad: other_ad) }

  let(:csv_content) do
    <<~CSV
      Ad set Name,test_start_date,test_end_date,cpi,cpm,ctr,cvr,impression,budget,amount_spent
      #{target_ad.file_name.delete_suffix(".mp4")},2026-09-01,2026-09-07,100,200,1.5,35.0,1000,10000,9000
    CSV
  end

  let(:valid_csv) do
    Rack::Test::UploadedFile.new(
      StringIO.new(csv_content),
      "text/csv",
      true,
      original_filename: "results.csv"
    )
  end

  describe "GET /ad_tests/results" do
    context "未ログインの場合" do
      it "ログイン画面にリダイレクトする" do
        get ad_tests_results_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みの場合" do
      before { sign_in user }

      it "テスト結果一覧画面を表示する" do
        get ad_tests_results_path

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /ad_tests" do
    let(:valid_params) do
      {
        ad_test: {
          app_id: target_app.id,
          csv: valid_csv,
          network: "Meta"
        }
      }
    end

    context "未ログインの場合" do
      it "ログイン画面にリダイレクトする" do
        post ad_tests_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みで、正しいCSVをアップロードした場合" do
      before do
        sign_in user
        target_ad_test
      end

      it "対象のAdTestに結果を取り込み、アプリ詳細画面にリダイレクトする" do
        post ad_tests_path, params: valid_params

        expect(response).to redirect_to(app_path(target_app))
        expect(target_ad_test.reload).to have_attributes(
          status: "結果取り込み済み",
          network: "Meta",
          cpi: 100,
          cpm: 200,
          ctr: 1.5,
          cvr: 35.0,
          impression: 1000,
          budget: 10000,
          amount_spent: 9000,
          test_start_date: Date.new(2026, 9, 1),
          test_end_date: Date.new(2026, 9, 7)
        )
      end
    end

    context "ログイン済みで、CSVファイルを選択しなかった場合" do
      before do
        sign_in user
        target_ad_test
      end

      it "結果を更新せずアプリ詳細画面にリダイレクトする" do
        expect {
          post ad_tests_path, params: { ad_test: { app_id: target_app.id, network: "Meta" } }
        }.not_to change { target_ad_test.reload.status }

        expect(response).to redirect_to(app_path(target_app))
        expect(flash[:alert]).to eq("CSVファイルを選択してください。")
      end
    end

    context "ログイン済みで、必要なヘッダーがないCSVをアップロードした場合" do
      before do
        sign_in user
        target_ad_test
      end

      let(:invalid_csv) do
        Rack::Test::UploadedFile.new(
          StringIO.new("Ad set Name,cpi\n#{target_ad.file_name.delete_suffix(".mp4")},100\n"),
          "text/csv",
          true,
          original_filename: "invalid_results.csv"
        )
      end

      it "結果を更新せずアプリ詳細画面にリダイレクトする" do
        expect {
          post ad_tests_path, params: {
            ad_test: { app_id: target_app.id, csv: invalid_csv, network: "Meta" }
          }
        }.not_to change { target_ad_test.reload.status }

        expect(response).to redirect_to(app_path(target_app))
        expect(flash[:alert]).to include("CSVファイルのヘッダーが要件を満たしていません。")
      end
    end
  end

  describe "PATCH /ad_tests/:id" do
    let(:valid_params) { { ad_test: { cpi: 100 } } }
    let(:invalid_params) { { ad_test: { cpi: -1 } } }

    context "未ログインの場合" do
      it "ログイン画面にリダイレクトする" do
        patch ad_test_path(target_ad_test), params: valid_params

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みで、自分のAdTestを正しい値で更新する場合" do
      before { sign_in user }

      it "テスト結果を更新してアプリ詳細画面にリダイレクトする" do
        patch ad_test_path(target_ad_test), params: valid_params

        expect(target_ad_test.reload.cpi).to eq(100)
        expect(response).to redirect_to(app_path(target_app))
      end
    end

    context "ログイン済みで、自分のAdTestを不正な値で更新する場合" do
      before { sign_in user }

      it "テスト結果を更新せずアプリ詳細画面を再表示する" do
        expect {
          patch ad_test_path(target_ad_test), params: invalid_params
        }.not_to change { target_ad_test.reload.cpi }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "ログイン済みで、他ユーザーのAdTestを更新する場合" do
      before { sign_in user }

      it "他ユーザーのAdTestは更新できない" do
        expect {
          patch ad_test_path(other_ad_test), params: valid_params
        }.not_to change { other_ad_test.reload.cpi }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /ad_tests/:id" do
    context "未ログインの場合" do
      it "ログイン画面にリダイレクトする" do
        delete ad_test_path(target_ad_test)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みで、自分のAdTestを削除する場合" do
      before do
        sign_in user
        target_ad_test
      end

      it "AdTestを削除してアプリ詳細画面にリダイレクトする" do
        expect {
          delete ad_test_path(target_ad_test)
        }.to change(AdTest, :count).by(-1)

        expect(response).to redirect_to(app_path(target_app))
      end
    end

    context "ログイン済みで、他ユーザーのAdTestを削除する場合" do
      before do
        sign_in user
        other_ad_test
      end

      it "他ユーザーのAdTestは削除できない" do
        expect {
          delete ad_test_path(other_ad_test)
        }.not_to change(AdTest, :count)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
