require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    context "nameが空の場合" do
      it "無効になる" do
        user = build(:user, name: "")
        expect(user).not_to be_valid
      end
    end

    context "nameが21文字以上の場合" do
      it "無効になる" do
        user = build(:user, name: "abcdeabcdeabcdeabcdea")
        expect(user).not_to be_valid
      end
    end

    context "すべての値が正しい場合" do
      it "有効になる" do
        user = build(:user)
        expect(user).to be_valid
      end
    end
  end

  describe "アソシエーション" do
    context "アプリとのリレーション" do
      it "Appにhas_manyで紐づいている" do
            expect(User.reflect_on_association(:apps).macro).to eq :has_many
      end
    end

    context "広告とのリレーション" do
      it "Adにhas_manyで紐づいている" do
            expect(User.reflect_on_association(:ads).macro).to eq :has_many
      end
    end

    context "仮説とのリレーション" do
      it "Hypothesisにhas_manyで紐づいている" do
            expect(User.reflect_on_association(:hypotheses).macro).to eq :has_many
      end
    end

    context "テスト結果とのリレーション" do
      it "AdTestにhas_many throughで紐づいている" do
            user = create(:user)
            ad = create(:ad, user: user)
            ad_test = create(:ad_test, ad: ad)
            expect(user.ad_tests).to include(ad_test)
      end
    end

    context "振り返りとのリレーション" do
      it "Reviewにhas_manyで紐づいている" do
            expect(User.reflect_on_association(:reviews).macro).to eq :has_many

      end
    end
  end
end
