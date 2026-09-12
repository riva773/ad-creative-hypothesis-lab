class App < ApplicationRecord
  validates :name, :user_id, presence: true

  belongs_to :user
  has_one_attached :avatar
end
