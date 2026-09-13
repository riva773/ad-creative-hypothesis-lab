class App < ApplicationRecord
  validates :name, :user_id, presence: true

  belongs_to :user
  has_many :hypotheses
  has_many :ads
  has_many :ad_tests, through: :ads
  has_one_attached :avatar
end
