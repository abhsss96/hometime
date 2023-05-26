module Api
  module V1
    module Resources
      class Reservations < Grape::API
        helpers Api::V1::Helpers::ReservationHelpers
        resources :reservations do
          desc 'Create Reservation'

          params do
            # Payload 1
            optional :reservation, type: Hash do
              requires :code, type: String
              optional :start_date, type: Date
              optional :end_date, type: Date
              optional :expected_payout_amount, type: Float, as: :payout_price
              optional :guest_details, type: Hash
              optional :guest_email, type: String, as: :email
              optional :guest_first_name, type: String, as: :first_name
              optional :guest_last_name, type: String, as: :last_name
              optional :guest_phone_numbers, type: Array, as: :phone_numbers
              optional :listing_security_price_accurate, type: String, as: :security_price
              optional :host_currency, type: String, as: :currency
              optional :nights, type: Integer
              optional :number_of_guests, type: Integer, as: :guests
              optional :status_type, type: String, as: :status
              optional :total_paid_amount_accurate, type: Float, as: :total_price
              optional :guest_details, type: Hash do
                optional :localized_description, type: String, as: :guests
                optional :number_of_adults, type: Integer, as: :adults
                optional :number_of_children, type: Integer, as: :children
                optional :number_of_infants, type: Integer, as: :infants
              end
            end

            # Payoad 2
            optional :reservation_code, type: String

            given :reservation_code do
              requires :reservation_code, type: String, as: :code
              optional :start_date, type: Date
              optional :end_date, type: Date
              optional :nights, type: Integer
              optional :guests, type: Integer
              optional :adults, type: Integer
              optional :children, type: Integer
              optional :infants, type: Integer
              optional :status, type: String
              optional :currency, type: String
              optional :payout_price, type: Float
              optional :security_price, type: Float
              optional :total_price, type: Float
              requires :guest, type: Hash, as: :guest_attributes do
                requires :email, type: String
                optional :first_name, type: String
                optional :last_name, type: String
                optional :phone, type: String, as: :phone_numbers
              end
            end

            exactly_one_of :reservation, :reservation_code
          end

          post do
            reservation = Reservation.find_by_code(permitted_params[:code])
            if reservation.blank?
              reservation = Reservation.create!(permitted_params)
            else
              guest_params = permitted_params.delete(:guest_attributes)
              reservation.update!(permitted_params)
              reservation.guest.update!(guest_params)
            end

            present reservation
          end
        end
        helpers do
          def permitted_params
            @permitted_params ||= convert_to_resource_params
          end
        end
      end
    end
  end
end
