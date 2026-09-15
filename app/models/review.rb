class Review < ApplicationRecord
  belongs_to :user
  belongs_to :ad_test

  validates :content, :user_id, :ad_test_id, presence: true
  validates :content, length: { maximum: 1000 }
  validates :ad_test_id, uniqueness: true


  def self.ransackable_attributes(auth_object = nil)
    %w[content]
  end
end
