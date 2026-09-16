class Ad < ApplicationRecord
  has_many :ad_tests, dependent: :destroy
  belongs_to :app
  belongs_to :user
  belongs_to :hypothesis
  has_one_attached :creative

  validate :file_name_match_app_campaign_name
  validate :app_id_match_hypothesis_app_id
  validates :file_name, :creative, presence: true
  validates :creative, size: { less_than_or_equal_to: 500.megabytes }
  validates :file_name, uniqueness: { scope: :app_id }
  validates :creative, content_type: "video/mp4"
  validates :hypothesis_id, uniqueness: true

  private

  def file_name_match_app_campaign_name
    return if file_name.blank?
    pattern = /\A#{Regexp.escape(app.campaign_name)}_[0-9]{3}\.mp4\z/
    unless file_name.match?(pattern)
      errors.add(:file_name, "は、キャンペーン名_3桁の番号.mp4の形式にしてください。")
    end
  end

  def app_id_match_hypothesis_app_id
    return if app_id.blank? || hypothesis_id.blank? || hypothesis.blank?
    unless app_id == hypothesis.app_id
      errors.add(:base, "広告と仮説はは、同じアプリに属している必要があります。")
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[file_name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[app hypothesis]
  end
end
