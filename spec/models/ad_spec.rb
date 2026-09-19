require 'rails_helper'

RSpec.describe Ad, type: :model do
  describe "バリデーション" do
    let(:user) { create(:user)
  }
    let(:app) { create(:app)
  }
    context "アプリが紐づいていない時" do
      it "無効になる" do
        ad = build(:ad)
        ad.app = nil
        expect(ad).not_to be_valid
      end
    end

    context "ユーザーが紐づいていない時" do
      it "無効になる" do
        ad = build(:ad, user: nil)
        expect(ad).not_to be_valid
      end
    end

    context "仮説が紐づいていない時" do
      it "無効になる" do
        ad = build(:ad, hypothesis: nil)
        expect(ad).not_to be_valid
      end
    end

    context "ファイル名が空の時" do
      it "無効になる" do
        ad = build(:ad, file_name: "")
        expect(ad).not_to be_valid
      end
    end

    context "動画が添付されていない時" do
      it "無効になる" do
        ad = build(:ad)
        ad.creative.detach
        expect(ad).not_to be_valid
      end
    end

    context "ファイル名がキャンペーン名_3桁の番号.mp4形式でない時" do
      it "無効になる" do
        ad = build(:ad, file_name: "test.mp4")
        expect(ad).not_to be_valid
      end
    end

    context "動画がmp4形式でない時" do
      it "無効になる" do
        ad = build(:ad)
        ad.creative.attach(
          io: StringIO.new("test file"),
          filename: ad.file_name,
          content_type: "text/plain"
        )
        expect(ad).not_to be_valid
      end
    end

    context "動画サイズが500MBを超える時" do
      it "無効になる" do
        ad = build(:ad)
        allow(ad.creative.blob).to receive(:byte_size).and_return(501.megabytes)
        expect(ad).not_to be_valid
      end
    end

    context "同じアプリに同じファイル名の広告が存在する時" do
      it "無効になる" do
        ad = create(:ad, app: app)
        duplication_ad = build(:ad, app: app, file_name: ad.file_name)
        expect(duplication_ad).not_to be_valid
      end
    end

    context "同じ仮説に紐づく広告がすでに存在する時" do
      it "無効になる" do
        ad = create(:ad)
        duplication_ad = build(
          :ad,
          user: ad.user,
          app: ad.app,
          hypothesis: ad.hypothesis,
          file_name: "#{ad.app.campaign_name}_002.mp4"
        )
        expect(duplication_ad).not_to be_valid
      end
    end

    context "広告と仮説が別のアプリに属している時" do
      it "無効になる" do
        duplication_app = create(:app, user: user)
        hypothesis = create(:hypothesis, user: user, app: app)
        ad = build(:ad, app: duplication_app, hypothesis: hypothesis)
        expect(ad).not_to be_valid
      end
    end

    context "すべての値が正しい時" do
      it "有効になる" do
        ad = build(:ad)
        expect(ad).to be_valid
      end
    end
  end

  describe "アソシエーション" do
    it { is_expected.to have_many(:ad_tests).dependent(:destroy) }
    it { is_expected.to belong_to(:app) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:hypothesis) }
    it { is_expected.to have_one_attached(:creative) }
  end

  describe ".ransackable_attributes" do
    it "file_nameを検索対象にする" do
      expect(Ad.ransackable_attributes).to eq(%w[file_name])
    end
  end

  describe ".ransackable_associations" do
    it "appとhypothesisを検索対象にする" do
      expect(Ad.ransackable_associations).to eq(%w[app hypothesis])
    end
  end
end
