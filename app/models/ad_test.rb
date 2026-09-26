class AdTest < ApplicationRecord
  belongs_to :ad
  has_one :review, dependent: :destroy

  validates :status, inclusion: { in: %w[ 結果取り込み済み テスト結果待ち 振り返り済み ] }
  validates :network, inclusion: { in: %w[ Meta Google AppLovin ], allow_nil: true }
  validates :cpi, :cpm, :impression, :budget, :amount_spent, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :ctr, :cvr, numericality: { in: 0..100 }, allow_nil: true
  validate :amount_spent_less_than_budget
  validate :test_end_date_must_be_after_test_start_date
  with_options if: :status_results_imported? do |model|
    model.validates :cpi, :ctr, :cvr, :impression, :cpm, :amount_spent, :budget, :test_start_date, :test_end_date, :network, presence: true
  end


  private

  def amount_spent_less_than_budget
    return if amount_spent.blank? || budget.blank?
    if amount_spent > budget
      errors.add(:amount_spent, "が予算を上回っています。")
    end
  end

  def status_results_imported?
    status == "結果取り込み済み" || status == "振り返り済み"
  end

  def test_end_date_must_be_after_test_start_date
    return if test_start_date.blank? || test_end_date.blank?
    if test_end_date < test_start_date
      errors.add(:test_end_date, "は開始日よりも後にしてください。")
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[cpi ctr cvr status test_start_date test_end_date]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ad review]
  end
end
