# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    code { SecureRandom.hex(11) }
    start_date { Date.today }
    end_date { Date.today + 1.day }
    nights { 1 }
    guests { 1 }
    adults { 1 }
    children { 1 }
    infants { 1 }
    status { 1 }
    currency { 'AUD' }
    payout_price { 1.5 }
    security_price { 1.5 }
    total_price { 1.5 }
  end
end
