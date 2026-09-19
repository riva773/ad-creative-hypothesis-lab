require 'rails_helper'

RSpec.describe AdTest, type: :model do
  let!(:user) { create(:user) }
  let!(:app) { create(:app) }
  let!(:ad) { create(:ad) }

  describe "バリデーション" do
    context "statusが許可されていない値の時" do
      it "無効になる" do
        ad_test = build(:ad_test, status: "不正なステータス")
        expect(ad_test).not_to be_valid
      end
    end

    context "networkが許可されていない値の時" do
      it "無効になる" do
        ad_test = build(:ad_test, network: "不正なnetwork")
        expect(ad_test).not_to be_valid
      end
    end

    context "CPI、CPM、imp、予算、消化金額が負の値の時" do
      it "無効になる" do
        ad_test = build(:ad_test, cpi: -2, cpm: -10, impression: -20, budget: -100, amount_spent: -200)
        expect(ad_test).not_to be_valid
      end
    end

    context "CTR、CVRが0から100の範囲外の時" do
      it "無効になる" do
        ad_test = build(:ad_test, ctr: 1000, cvr: -2000)
        expect(ad_test).not_to be_valid
      end
    end

    context "消化金額が予算を上回る時" do
      it "無効になる" do
        ad_test = build(:ad_test, budget: 10000, amount_spent: 20000)
        expect(ad_test).not_to be_valid
      end
    end

    context "計測終了日が計測開始日より前の時" do
      it "無効になる" do
        ad_test = build(:ad_test, test_start_date: Date.new(2026,9,15), test_end_date: Date.new(2025,4,1))
        expect(ad_test).not_to be_valid
      end
    end

    context "結果取り込み済みで必要な計測値が不足している時" do
      it "無効になる" do
        ad_test = build(:ad_test, status: "結果取り込み済み")
        expect(ad_test).not_to be_valid
      end
    end

    context "振り返り済みで必要な計測値が不足している時" do
      it "無効になる" do
        ad_test = build(:ad_test, status: "振り返り済み")
        expect(ad_test).not_to be_valid
      end
    end

    context "広告が紐づいていない時" do
      it "無効になる" do
        ad_test = build(:ad_test, ad: nil)
        expect(ad_test).not_to be_valid
      end
    end

    context "テスト結果待ちで計測値が未入力の時" do
      it "有効になる" do
        ad_test = build(:ad_test)
        expect(ad_test).to be_valid
      end
    end

    context "結果取り込み済みで必要な計測値がすべてある時" do
      it "有効になる" do
        ad_test = build(
          :ad_test,
          status: "結果取り込み済み",
          cpi: 100,
          cpm: 1000,
          ctr: 1.5,
          cvr: 25.0,
          impression: 10000,
          budget: 10000,
          amount_spent: 8000,
          test_start_date: Date.new(2026, 9, 1),
          test_end_date: Date.new(2026, 9, 7),
          network: "Meta")
        expect(ad_test).to be_valid
      end
    end

    context "振り返り済みで必要な計測値がすべてある時" do
      it "有効になる" do
        ad_test = build(
          :ad_test,
          status: "振り返り済み",
          cpi: 100,
          cpm: 1000,
          ctr: 1.5,
          cvr: 25.0,
          impression: 10000,
          budget: 10000,
          amount_spent: 8000,
          test_start_date: Date.new(2026, 9, 1),
          test_end_date: Date.new(2026, 9, 7),
          network: "Meta")
        expect(ad_test).to be_valid
      end
    end
  end

  describe "アソシエーション" do
    context "広告とのリレーション" do
      it { is_expected.to belong_to(:ad) }
    end

    context "振り返りとのリレーション" do
      it { is_expected.to have_one(:review).dependent(:destroy) }
    end
  end

  describe "メソッド" do
    context "消化金額と予算の関係を確認するメソッド" do
      it "消化金額が予算以下か確認する" do
        ad_test = build(:ad_test, budget: 10000, amount_spent: 10001)
        expect(ad_test).not_to be_valid
      end
    end

    context "計測終了日と計測開始日の関係を確認するメソッド" do
      it "計測終了日が計測開始日より後か確認する" do
        ad_test = build(
          :ad_test,
          test_start_date: Date.new(2026, 9, 15),
          test_end_date: Date.new(2026, 9, 14)
        )
        expect(ad_test).not_to be_valid
      end
    end
  end

  describe ".ransackable_attributes" do
    it "検索可能な属性を返す" do
      expect(AdTest.ransackable_attributes).to eq(
        %w[cpi ctr cvr status test_start_date test_end_date]
      )
    end
  end

  describe ".ransackable_associations" do
    it "検索可能な関連を返す" do
      expect(AdTest.ransackable_associations).to eq(%w[ad review])
    end
  end
end
