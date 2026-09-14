class AdTest < ApplicationRecord
  belongs_to :ad
  has_one :review, dependent: :destroy

  validates :status, inclusion: { in: %w[ 結果取り込み済み テスト結果待ち 振り返り済み ] }
  validates :network, inclusion: { in: %w[ Meta Google AppLovin ], allow_nil: true }

  def self.ransackable_attributes(auth_object = nil)
    %w[cpi ctr cvr status test_start_date test_end_date]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ad review]
  end
end
