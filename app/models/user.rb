class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :name, :role, presence: true
  validates :role, inclusion: { in: %w[ admin user ] }

  has_many :apps
  has_many :ads
  has_many :hypotheses
  has_many :ad_tests, through: :ads
end
