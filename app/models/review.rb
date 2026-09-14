class Review < ApplicationRecord
  belongs_to :user
  belongs_to :ad_test

  validates :user_id,:ad_test_id, presence: true
end
