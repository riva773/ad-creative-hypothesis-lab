class Hypothesis < ApplicationRecord
  belongs_to :user
  belongs_to :app
  has_one :ad
end
