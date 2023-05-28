# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reservations', type: :request do
  describe 'POST /api/v1/reservations' do
    let(:parsed_body) { JSON.parse(response.body).with_indifferent_access }
    let(:reservation) { Reservation.last }
    let(:payload_type_one) do
      {
        "reservation": {
          "code": 'XXX12345678',
          "start_date": '2021-03-12',
          "end_date": '2021-03-16',
          "expected_payout_amount": '3800.00',
          "guest_details": {
            "localized_description": '4 guests',
            "number_of_adults": 2,
            "number_of_children": 2,
            "number_of_infants": 0
          },
          "guest_email": 'wayne_woodbridge@bnb.com', "guest_first_name": 'Wayne',
          "guest_last_name": 'Woodbridge',
          "guest_phone_numbers": %w[
            639123456789
            639123456789
          ],
          "listing_security_price_accurate": '500.00', "host_currency": 'AUD',
          "nights": 4,
          "number_of_guests": 4,
          "status_type": 'accepted',
          "total_paid_amount_accurate": '4300.00'
        }
      }
    end
    let(:payload_type_two) do
      {
        "reservation_code": 'YYY12345678',
        "start_date": '2021-04-14',
        "end_date": '2021-04-18',
        "nights": 4,
        "guests": 4,
        "adults": 2,
        "children": 2,
        "infants": 0,
        "status": 'accepted',
        "guest": {
          "first_name": 'Wayne',
          "last_name": 'Woodbridge',
          "phone": '639123456789',
          "email": 'wayne_woodbridge@bnb.com'
        },
        "currency": 'AUD',
        "payout_price": '4200.00',
        "security_price": '500',
        "total_price": '4700.00'
      }
    end

    context 'with payload type one' do
      it 'creates reservation with guest information' do
        post '/api/v1/reservations', params: payload_type_one

        expect(response.status).to eq(201)
        expect(parsed_body[:code]).to eq(payload_type_one[:reservation][:code])
        expect(reservation.guest.email).to eq(payload_type_one[:reservation][:guest_email])
      end

      context 'when reservation already present with same code.' do
        let(:guest) { FactoryBot.create(:guest) }
        let!(:reservation_one) do
          FactoryBot.create(:reservation,
                            code: payload_type_one[:reservation][:code],
                            guest: guest)
        end

        before { payload_type_one[:reservation][:status_type] = 'new' }

        it 'updates the reservation and guest details' do
          post '/api/v1/reservations', params: payload_type_one

          expect(response.status).to eq(201)
          expect(parsed_body[:code]).to eq(payload_type_one[:reservation][:code])
          expect(parsed_body[:status]).to eq('new')
          expect(reservation.guest.email).to eq(payload_type_one[:reservation][:guest_email])
        end
      end

      context 'when payload does not have reservation code.' do
        before { payload_type_one[:reservation][:code] = nil }

        it 'returns 422' do
          post '/api/v1/reservations', params: payload_type_one

          expect(response.status).to eq(422)
          expect(parsed_body[:errors][:status]).to eq('Unprocessable Entity')
          expect(parsed_body[:errors][:message]).to eq("Code can't be blank")
        end
      end

      context 'when payload does not have guest email.' do
        before { payload_type_one[:reservation][:guest_email] = nil }

        it 'returns 422' do
          post '/api/v1/reservations', params: payload_type_one

          expect(response.status).to eq(422)
          expect(parsed_body[:errors][:status]).to eq('Unprocessable Entity')
          expect(parsed_body[:errors][:message]).to eq("Email can't be blank")
        end
      end
    end

    context 'with payload type two' do
      it 'creates reservation  with guest information' do
        post '/api/v1/reservations', params: payload_type_two

        expect(response.status).to eq(201)
        expect(parsed_body[:code]).to eq(payload_type_two[:reservation_code])
        expect(reservation.guest.email).to eq(payload_type_two[:guest][:email])
      end

      context 'when reservation already present with same code.' do
        let(:guest) { FactoryBot.create(:guest) }
        let!(:reservation_one) do
          FactoryBot.create(:reservation,
                            code: payload_type_two[:reservation_code],
                            guest: guest)
        end

        before { payload_type_two[:status] = 'booked' }

        it 'updates the reservation and guest details' do
          post '/api/v1/reservations', params: payload_type_two

          expect(response.status).to eq(201)
          expect(parsed_body[:code]).to eq(payload_type_two[:reservation_code])
          expect(parsed_body[:status]).to eq('booked')
          expect(reservation.guest.email).to eq(payload_type_two[:guest][:email])
        end
      end

      context 'when payload does not have reservation code.' do
        before { payload_type_two.delete(:reservation_code) }

        it 'returns 422' do
          post '/api/v1/reservations', params: payload_type_two

          expect(response.status).to eq(400)

          expect(parsed_body[:error]).to eq(
            'reservation, reservation_code are missing, exactly one parameter must be provided'
          )
        end
      end

      context 'when payload does not have guest email.' do
        before { payload_type_two[:guest][:email] = nil }

        it 'returns 422' do
          post '/api/v1/reservations', params: payload_type_two

          expect(response.status).to eq(422)
          expect(parsed_body[:errors][:status]).to eq('Unprocessable Entity')
          expect(parsed_body[:errors][:message]).to eq("Email can't be blank")
        end
      end
    end
  end
end
