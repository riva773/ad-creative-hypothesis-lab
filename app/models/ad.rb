class Ad < ApplicationRecord
  has_many :ad_tests, dependent: :destroy
  belongs_to :app
  belongs_to :user
  belongs_to :hypothesis
  has_one_attached :creative
end
