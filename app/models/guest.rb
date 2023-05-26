class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validate :email, presence: true, unique: true
  serialize :phone_numbers


end
