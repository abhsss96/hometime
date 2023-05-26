FactoryBot.define do
  factory :guest do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.first_name }
    phone_numbers { [ Faker::PhoneNumber.phone_number ] }
  end
end
