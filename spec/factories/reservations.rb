FactoryBot.define do
  factory :reservation do
    code { "MyString" }
    start_date { "2023-05-25" }
    end_date { "2023-05-25" }
    nights { 1 }
    guests { 1 }
    adults { 1 }
    children { 1 }
    infants { 1 }
    status { 1 }
    currency { "MyString" }
    guest_id { 1 }
    payout_price { 1.5 }
    security_price { 1.5 }
    total_price { 1.5 }
  end
end
