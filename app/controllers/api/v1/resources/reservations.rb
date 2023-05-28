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
      end
    end
  end
end
