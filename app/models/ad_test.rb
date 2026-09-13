class AdTest < ApplicationRecord
  belongs_to :ad
  validates :status, inclusion: { in: %w[ 結果取り込み済み テスト結果待ち 振り返り済み ] }
  validates :network, inclusion: { in: %w[ Meta Google AppLovin ] }
end
