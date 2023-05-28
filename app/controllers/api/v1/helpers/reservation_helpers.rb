# frozen_string_literal: true

module Api
  module V1
    module Helpers
      module ReservationHelpers
        extend Grape::API::Helpers

        def convert_payload_to_params
          return ::PayloadTypeOne.new(params) if params[:reservation].present?
          return ::PayloadTypeTwo.new(params) if params[:reservation_code].present?
        end

        def reservation_params
          ActionController::Parameters.new(convert_payload_to_params.reservation_params)
        end

        def guest_params
          ActionController::Parameters.new(convert_payload_to_params.guest_params)
        end

        def create_or_update_reservation
          guest = Guest.find_or_initialize_by(email: permitted_guest_params[:email])
          reservation = Reservation.find_or_initialize_by(code: permitted_reservation_params[:code])

          ActiveRecord::Base.transaction do
            guest.update!(permitted_guest_params)
            reservation.update!(permitted_reservation_params.merge(guest_id: guest.id))
          end
          reservation
        end

        def permitted_guest_params
          guest_params.require(:guest).permit(
            :id,
            :email,
            :first_name,
            :last_name,
            phone_numbers: []
          )
        end

        def permitted_reservation_params
          reservation_params.require(:reservation).permit(
            :code,
            :start_date,
            :end_date,
            :nights,
            :guests,
            :adults,
            :children,
            :infants,
            :status,
            :currency,
            :guest_id,
            :payout_price,
            :security_price,
            :total_price
          )
        end
      end
    end
  end
end
