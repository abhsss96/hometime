# frozen_string_literal: true

module Api
  module V1
    class Root < Grape::API
      format :json

      rescue_from ActiveRecord::RecordNotFound do |_exception|
        ErrorHandler.notify_exception(exception)

        error!({
                 errors: {
                   status: 'Not Found',
                   message: 'Record not found'
                 }
               },
               404)
      end

      rescue_from ActiveRecord::RecordInvalid do |exception|
        ErrorHandler.notify_exception(exception)

        errors = exception.record.errors

        error!(
          {
            errors: {
              status: 'Unprocessable Entity',
              message: errors.full_messages.join(','),
              error_codes: errors.details.inject([]) do |a, (k, v)|
                                                                                 a << v.collect do |j|
                                                                                   "#{k}_#{j[:error]}"
                                                                                 end; end.flatten,
              entity_with_error: exception.record.to_json
            }
          },
          422
        )
      end

      mount Api::V1::Resources::Reservations
    end
  end
end
