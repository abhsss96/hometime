# frozen_string_literal: true

module Api
  module V1
    module Helpers
      module ReservationHelpers
        extend Grape::API::Helpers
        
        def convert_payload_to_resource_params
          return ::PayloadTypeOne.new(params).params if params[:reservation].present?
          return ::PayloadTypeTwo.new(params).params if params[:reservation_code].present?

          {}
        end

        def strong_parameters
          ActionController::Parameters.new(convert_payload_to_resource_params)
        end
      end
    end
  end
end
