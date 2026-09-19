require "rails_helper"

RSpec.describe "Hypotheses", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:target_app) { create(:app, user: user) }
  let(:other_app) { create(:app, user: other_user) }
  let(:target_hypothesis) { create(:hypothesis, app: target_app, user: user) }
  let(:other_hypothesis) { create(:hypothesis, app: other_app, user: other_user) }

  describe "POST /hypotheses" do
    let(:valid_params) do
      {
        hypothesis: {
          content: "訴求内容を明確にすると、CTRが上がる",
          app_id: target_app.id
        }
      }
    end

    let(:invalid_params) do
      {
        hypothesis: {
          content: "",
          app_id: target_app.id
        }
      }
    end

    context "未ログインの場合" do
      it "ログイン画面にリダイレクトする" do
        post hypotheses_path, params: invalid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みで、入力値が正しい場合" do
      before { sign_in user }

      it "仮説を作成してアプリ詳細画面にリダイレクトする" do
        expect {
          post hypotheses_path,
          params: valid_params
      }.to change(Hypothesis, :count).by(1)

        expect(response).to redirect_to(app_path(target_app))
      end
    end

    context "ログイン済みで、入力値が正しくない場合" do
      before { sign_in user }

      it "仮説を作成せずアプリ詳細画面を再表示する" do
        expect {
          post hypotheses_path,
          params: invalid_params
      }.not_to change(Hypothesis, :count)

      expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /hypotheses/:id" do
    let(:valid_params) { { hypothesis: { content: "更新後の仮説" } } }
    let(:invalid_params) { { hypothesis: { content: "" } } }

    context "未ログインの場合" do
      it "ログイン画面にリダイレクトする" do
        patch hypothesis_path(target_app)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みで、自分の仮説を正しい値で更新する場合" do
      before { sign_in user }
      let(:updated_params) do
        {
          hypothesis: {
            content: "更新後の仮説"
          }
        }
      end

      it "仮説を更新してアプリ詳細画面にリダイレクトする" do
          patch hypothesis_path(target_hypothesis), params: updated_params
          expect(response).to redirect_to(app_path(target_hypothesis.app))
      end
    end

    context "ログイン済みで、自分の仮説を不正な値で更新する場合" do
      before { sign_in user }

      it "仮説を更新せずアプリ詳細画面を再表示する" do
        expect {
          patch hypothesis_path(target_hypothesis),
          params: invalid_params
      }.not_to change { target_hypothesis.reload.content }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "ログイン済みで、他ユーザーの仮説を更新する場合" do
      before { sign_in user }
      it "他ユーザーの仮説は更新できない" do
        expect {
          patch hypothesis_path(other_hypothesis),
          params: valid_params
        }.not_to change { other_hypothesis.reload.content }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /hypotheses/:id" do
    context "未ログインの場合" do
      it "ログイン画面にリダイレクトする" do
        delete hypothesis_path(target_hypothesis)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みで、自分の仮説を削除する場合" do
      before { sign_in user }

      it "仮説を削除してアプリ詳細画面にリダイレクトする" do
        target_hypothesis
        expect {
          delete hypothesis_path(target_hypothesis)
        }.to change(Hypothesis, :count).by(-1)

        expect(response).to redirect_to(app_path(target_app))
      end
    end

    context "ログイン済みで、他ユーザーの仮説を削除する場合" do
      before { sign_in user }

      it "他ユーザーの仮説は削除できない" do
        other_hypothesis
        expect {
          delete hypothesis_path(other_hypothesis)
        }.not_to change(Hypothesis, :count)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
