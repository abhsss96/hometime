# frozen_string_literal: true

module Api
  module V1
    module Resources
      class Reservations < Grape::API
        helpers Api::V1::Helpers::ReservationHelpers
        resources :reservations do
          desc 'Create Reservation'

          params do
            # Payload 1
            optional :reservation, type: Hash

            # Payload 2
            optional :reservation_code, type: String

            exactly_one_of :reservation, :reservation_code
          end

          post do
            reservation = Reservation.find_by_code(reservation_params[:code])
            if reservation.blank?
              reservation = Reservation.create!(create_reservation_params)
            else
              reservation.update!(reservation_params)
            end

            present reservation
          end
        end

        helpers do
          def create_reservation_params
            guest = Guest.find_by_email(reservation_params[:guest_attributes][:email])
            return reservation_params unless guest
          
            reservation_params.except(:guest_attributes).merge(guest_id: guest.id)
          end

          def reservation_params
            strong_parameters.require(:reservation).permit( :code, :start_date, :end_date,
            :nights, :guests, :adults, :children, :infants, :status, :currency, :guest_id,
            :payout_price, :security_price, :total_price, guest_attributes: [ :id, :email,
            :first_name, :last_name, :phone_numbers => []])
          end
        end
      end
    end
  end
end
