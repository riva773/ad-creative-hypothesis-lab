require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "バリデーション" do
    context "ユーザーが紐づいていない時" do
      it "無効になる" do
        review = build(:review, user: nil)
        expect(review).not_to be_valid
      end
    end

    context "テスト結果が紐づいていない時" do
      it "無効になる" do
        review = build(:review, ad_test: nil)
        expect(review).not_to be_valid
      end
    end

    context "振り返り内容が空の時" do
      it "無効になる" do
        review = build(:review, content: "")
        expect(review).not_to be_valid
      end
    end

    context "振り返り内容が1000文字を超える時" do
      it "無効になる" do
        long_str = "a" * 1001
        review = build(:review, content: long_str)
        expect(review).not_to be_valid
      end
    end

    context "同じテスト結果に紐づく振り返りがすでに存在する時" do
      it "無効になる" do
        review = create(:review)
        duplication_review = build(:review, ad_test: review.ad_test)
        expect(duplication_review).not_to be_valid
      end
    end

    context "すべての値が正しい時" do
      it "有効になる" do
        review = create(:review)
        expect(review).to be_valid
      end
    end
  end

  describe "アソシエーション" do
    context "ユーザーとのリレーション" do
      it "Userにbelongs_toで紐づいている" do
        expect(Review.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context "テスト結果とのリレーション" do
      it "AdTestにbelongs_toで紐づいている" do
        expect(Review.reflect_on_association(:ad_test).macro).to eq :belongs_to
      end
    end
  end

  describe ".ransackable_attributes" do
    it "contentを検索対象にする" do
      expect(Review.ransackable_attributes).to include("content")
    end
  end
end
