class App < ApplicationRecord
  validates :name, :user_id, presence: true
  validates :campaign_name, presence: true, uniqueness: true

  belongs_to :user
  has_many :hypotheses, dependent: :destroy
  has_many :ads, dependent: :destroy
  has_many :ad_tests, through: :ads, dependent: :destroy
  has_one_attached :avatar
end
