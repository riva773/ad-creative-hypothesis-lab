class Hypothesis < ApplicationRecord
  belongs_to :user
  belongs_to :app
  has_one :ad, dependent: :destroy

  validates :content, presence: true
  validates :content, length: { maximum: 150}

  def self.ransackable_attributes(auth_object = nil)
    %w[content]
  end
end
