require 'rails_helper'

RSpec.describe Hypothesis, type: :model do
  let!(:user) { create(:user) }
  let!(:app) { create(:app) }

  describe "バリデーション" do
    context "内容が空の時" do
      it "無効になる" do
        hypothesis = build(:hypothesis, content: "", user: user, app: app )
        expect(hypothesis).not_to be_valid
      end
    end

    context "内容が150文字を超える時" do
      it "無効になる" do
        long_str = "a"*151
        hypothesis = build(:hypothesis, content: long_str, user: user, app: app )
        expect(hypothesis).not_to be_valid
      end
    end

    context "すべての値が正しい時" do
      it "有効になる" do
        hypothesis = build(:hypothesis, user: user, app: app)
        expect(hypothesis).to be_valid
      end
    end
  end

  describe "アソシエーション" do
    context "ユーザーとのリレーション" do
      it "Userにbelongs_toで紐づいている" do
            expect(Hypothesis.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context "アプリとのリレーション" do
      it "Appにbelongs_toで紐づいている" do
        expect(Hypothesis.reflect_on_association(:app).macro).to eq :belongs_to
      end
    end

    context "広告とのリレーション" do
      it "Adにhas_oneで紐づいている" do
        expect(Hypothesis.reflect_on_association(:ad).macro).to eq :has_one
      end
    end
  end

  describe ".ransackable_attributes" do
    it "contentを検索対象にする" do
            expect(Hypothesis.ransackable_attributes).to include("content")
    end
  end
end
