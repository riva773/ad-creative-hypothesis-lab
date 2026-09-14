class Hypothesis < ApplicationRecord
  belongs_to :user
  belongs_to :app
  has_one :ad

  def self.ransackable_attributes(auth_object = nil)
    %w[content]
  end
end
