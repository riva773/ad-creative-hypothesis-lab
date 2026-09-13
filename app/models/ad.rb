class Ad < ApplicationRecord
  has_many :ad_tests, dependent: :destroy
  belongs_to :app
  belongs_to :user
  belongs_to :hypothesis
  has_one_attached :creative

  validate :file_name_match_app_campaign_name

  def file_name_match_app_campaign_name
    pattern = /\A#{app.campaign_name}_[0-9]{3}\.mp4\z/
    unless file_name.match?(pattern)
      errors.add(:file_name, "は、キャンペーン名_3桁の番号.mp4の形式にしてください。")
    end
  end
end
