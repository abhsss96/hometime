module Api
  module V1
    module Helpers
      module ReservationHelpers
        extend Grape::API::Helpers

        def convert_to_resource_params
          p = declared(params, evaluate_given: true, include_missing: false)
          return parse_payload_type_one(p) if p[:code]
          return parse_payload_type_two(p[:reservation]) if p[:reservation]
        end

        def parse_payload_type_one(p)
          p[:guest_attributes][:phone_numbers] = [p[:guest_attributes].delete(:phone_numbers)] if p[:guest_attributes]
          p
        end

        def parse_payload_type_two(p)
          # Format guest details hash
          if p[:guest_details]
            %w[guests adults children infants].each { |attr| p[attr] = p[:guest_details][attr] }
            p.delete(:guest_details)
          end

          # Convert localisation of guests
          p[:guests] = p[:guests].try(:to_i)

          # Format guest information
          p[:guest_attributes] = {}
          %w[email first_name last_name phone_numbers].each do |attr|
            p[:guest_attributes][attr] = p.delete(attr)
          end
          p
        end
      end
    end
  end
end
