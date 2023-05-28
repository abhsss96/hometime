# frozen_string_literal: true

module Api
  module V1
    module Helpers
      module ReservationHelpers
        extend Grape::API::Helpers

        def convert_payload_to_resource_params
          return ::PayloadTypeOne.new(params).params if params[:reservation].present?
          return ::PayloadTypeTwo.new(params).params if params[:reservation_code].present?
        end

        def strong_parameters
          ActionController::Parameters.new(convert_payload_to_resource_params)
        end

        def create_reservation_params
          guest = Guest.find_by_email(reservation_params[:guest_attributes][:email])
          return reservation_params unless guest

          reservation_params.except(:guest_attributes).merge(guest_id: guest.id)
        end

        def reservation_params
          strong_parameters.require(:reservation).permit(
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
            :total_price,
            guest_attributes:
            [
              :id,
              :email,
              :first_name,
              :last_name,
              { phone_numbers: [] }
            ]
          )
        end
      end
    end
  end
end
