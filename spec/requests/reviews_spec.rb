require "rails_helper"

RSpec.describe "Reviews", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:target_app) { create(:app, user: user) }
  let(:target_hypothesis) { create(:hypothesis, app: target_app, user: user) }
  let(:target_ad) { create(:ad, app: target_app, hypothesis: target_hypothesis, user: user) }
  let(:result_attributes) do
    {
      status: "結果取り込み済み",
      network: "Meta",
      cpi: 100,
      cpm: 200,
      ctr: 1.5,
      cvr: 35.0,
      impression: 1000,
      budget: 10_000,
      amount_spent: 9000,
      test_start_date: Date.new(2026, 9, 1),
      test_end_date: Date.new(2026, 9, 7)
    }
  end
  let(:target_ad_test) { create(:ad_test, ad: target_ad, **result_attributes) }
  let(:target_review) { create(:review, user: user, ad_test: target_ad_test) }
  let(:other_app) { create(:app, user: other_user) }
  let(:other_hypothesis) { create(:hypothesis, app: other_app, user: other_user) }
  let(:other_ad) { create(:ad, app: other_app, hypothesis: other_hypothesis, user: other_user) }
  let(:other_ad_test) { create(:ad_test, ad: other_ad, **result_attributes) }
  let(:other_review) { create(:review, user: other_user, ad_test: other_ad_test) }

  describe "POST /reviews" do
    let(:valid_params) do
      {
        review:
          { ad_test_id: target_ad_test.id, content: "今回の広告は仮説どおりに機能した。" }
      }
    end

    context "未ログインの場合" do
      it "ログイン画面にリダイレクトする" do
        post reviews_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みで、結果取り込み済みのAdTestに正しい内容を送る場合" do
      before do
        sign_in user
        target_ad_test
      end

      it "振り返りを作成してAdTestを振り返り済みにする" do
        expect {
          post reviews_path, params: valid_params
        }.to change(Review, :count).by(1)

        expect(target_ad_test.reload.status).to eq("振り返り済み")
        expect(Review.last).to have_attributes(user: user, ad_test: target_ad_test, content: "今回の広告は仮説どおりに機能した。")
        expect(response).to redirect_to(app_path(target_app))
      end
    end

    context "ログイン済みで、テスト結果待ちのAdTestに振り返りを送る場合" do
      let(:target_ad_test) { create(:ad_test, ad: target_ad, status: "テスト結果待ち") }

      before do
        sign_in user
        target_ad_test
      end

      it "振り返りを作成せずアプリ詳細画面を再表示する" do
        expect {
          post reviews_path, params: valid_params
        }.not_to change(Review, :count)

        expect(target_ad_test.reload.status).to eq("テスト結果待ち")
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "ログイン済みで、不正な内容を送る場合" do
      before do
        sign_in user
        target_ad_test
      end

      it "振り返りを作成せずアプリ詳細画面を再表示する" do
        invalid_params =
          {
            review:
              { ad_test_id: target_ad_test.id, content: ""
              }
          }

        expect {
          post reviews_path, params: invalid_params
        }.not_to change(Review, :count)

        expect(target_ad_test.reload.status).to eq("結果取り込み済み")
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "ログイン済みで、他ユーザーのAdTestに振り返りを送る場合" do
      before do
        sign_in user
        other_ad_test
      end

      it "他ユーザーのAdTestには振り返りを作成できない" do
        params = { review: { ad_test_id: other_ad_test.id, content: "振り返り" } }

        expect {
          post reviews_path, params: params
        }.not_to change(Review, :count)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH /reviews/:id" do
    let(:valid_params) { { review: { content: "更新後の振り返り" } } }
    let(:invalid_params) { { review: { content: "" } } }

    context "未ログインの場合" do
      it "ログイン画面にリダイレクトする" do
        patch review_path(target_review), params: valid_params

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みで、自分の振り返りを正しい値で更新する場合" do
      before { sign_in user }

      it "振り返りを更新してアプリ詳細画面にリダイレクトする" do
        patch review_path(target_review), params: valid_params

        expect(target_review.reload.content).to eq("更新後の振り返り")
        expect(response).to redirect_to(app_path(target_app))
      end
    end

    context "ログイン済みで、自分の振り返りを不正な値で更新する場合" do
      before { sign_in user }

      it "振り返りを更新せずアプリ詳細画面を再表示する" do
        expect {
          patch review_path(target_review), params: invalid_params
        }.not_to change { target_review.reload.content }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "ログイン済みで、他ユーザーの振り返りを更新する場合" do
      before do
        sign_in user
        other_review
      end

      it "他ユーザーの振り返りは更新できない" do
        expect {
          patch review_path(other_review), params: valid_params
        }.not_to change { other_review.reload.content }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
