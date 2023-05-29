# frozen_string_literal: true

class CreateOrUpdateReservation
  attr_reader :errors, :reservation

  def initialize(payload)
    @errors = []
    @payload = payload
    @reservation = nil
    process
  end

  def process
    if processed_payload_errors.blank?
      create_or_update_reservation
    else
      @errors.concat(processed_payload_errors)
    end
    [@reservation, @errors]
  end

  private

  def processed_payload_errors
    return processed_payload.errors if processed_payload
    
    ["reservation or reservation_code missing."]
  end

  def processed_payload
    return ::PayloadTypeOne.new(@payload) if @payload[:reservation] && @payload[:reservation][:code].present?
    return ::PayloadTypeTwo.new(@payload) if @payload[:reservation_code].present?
  end

  def create_or_update_reservation
    guest = Guest.find_or_initialize_by(email: permitted_guest_params[:email])
    @reservation = Reservation.find_or_initialize_by(code: permitted_reservation_params[:code])

    ActiveRecord::Base.transaction do
      guest.update!(permitted_guest_params)
      @reservation.update!(permitted_reservation_params.merge(guest_id: guest.id))
    end
  end

  def reservation_params
    ActionController::Parameters.new(processed_payload.reseravtion_params)
  end

  def guest_params
    ActionController::Parameters.new(processed_payload.guest_params)
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
