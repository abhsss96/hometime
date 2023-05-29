# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |_exception|
    render json: { message: 'Unprocessable Entity', errors: 'Record not found' }, status: 404
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    errors = exception.record.errors
    render json: { message: 'Invalid Entity', errors: errors.full_messages.join(', ') }, status: 422
  end
end
