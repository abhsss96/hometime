class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  serialize :phone_numbers
end
