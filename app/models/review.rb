class Review < ApplicationRecord
  belongs_to :user
  belongs_to :ad_test

  validates :user_id, :ad_test_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[content]
  end
end
