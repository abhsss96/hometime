# frozen_string_literal: true

class ReservationsController < ApplicationController
  def create
    @create_or_update_reservation = CreateOrUpdateReservation.new(params)
    if @create_or_update_reservation.errors.blank?
      render json: @create_or_update_reservation.reservation.to_json(include: :guest), status: 201
    else
      render json: { errors: @create_or_update_reservation.errors.flatten.uniq.join(', ') }, status: 422
    end
  end
end
