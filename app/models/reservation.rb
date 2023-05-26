# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :guest
  accepts_nested_attributes_for :guest

  validates :code, presence: true, uniqueness: true
end
