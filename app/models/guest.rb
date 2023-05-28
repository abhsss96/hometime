# frozen_string_literal: true

class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy, inverse_of: :guest

  validates :email, presence: true, uniqueness: true
  serialize :phone_numbers
end
