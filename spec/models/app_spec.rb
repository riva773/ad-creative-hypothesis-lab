require "rails_helper"

RSpec.describe App, type: :model do
  let(:user) { create(:user) }

  describe "バリデーション" do
    context "nameがからの時" do
      it "無効になる" do
        app = build(:app, name: "", user: user)
        expect(app).not_to be_valid
      end
    end
  end

  context "キャンペーン名が空の時" do
    it "無効になる" do
      app = build(:app, campaign_name: "", user: user)
      expect(app).not_to be_valid
    end
  end

  context "キャンペーン名が重複している時" do
    it "無効になる" do
      app = create(:app, campaign_name: "sample_campaign")
      duplication_app = build(:app, campaign_name: "sample_campaign", user: user)
      expect(duplication_app).not_to be_valid
    end
  end

  context "すべての値が正しい時" do
    it "有効になる" do
      app = build(:app, user: user)
      expect(app).to be_valid
    end
  end

  describe "アソシエーション" do
    context "ユーザーとのリレーション" do
      it { is_expected.to belong_to(:user) }
    end

    context "仮説とのリレーション" do
      it { is_expected.to have_many(:hypotheses) }
    end

    context "広告とのリレーション" do
      it { is_expected.to have_many(:ads) }
    end

    context "テスト結果とのリレーション" do
      it "AdTestにhas_many throughで紐づいている" do
        user = create(:user)
        app = create(:app, user: user)
        hypothesis = create(:hypothesis, user: user, app: app)
        ad = create(:ad, app: app, hypothesis: hypothesis, user: user)
        ad_test = create(:ad_test, ad: ad)
        expect(app.ad_tests).to include(ad_test)
      end
    end

    context "アバターとのリレーション" do
      it { should have_one_attached(:avatar) }
    end
  end

  describe ".ransackable_attributes" do
    it "検索可能な属性を返す" do
      expect(App.ransackable_attributes).to eq(%w[name])
    end
  end

  describe ".ransackable_associations" do
    it "検索可能な関連を返す" do
      expect(App.ransackable_associations).to eq([])
    end
  end
end
