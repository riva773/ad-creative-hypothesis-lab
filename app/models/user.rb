class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :name, length: { maximum: 20 }

  has_many :apps
  has_many :ads
  has_many :hypotheses
  has_many :ad_tests, through: :ads
  has_many :reviews
end
