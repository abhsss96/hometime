# frozen_string_literal: true

class PayloadTypeTwo
  def initialize(payload)
    @payload = payload
    @guest_payload = payload[:guest]
    @reseravtion_params = {}
    @guest_params = {}
    convert
  end

  def reservation
    @reseravtion_params[:reservation] ||= {}
  end

  def reservation_params
    @reseravtion_params
  end

  def guest
    @guest_params[:guest] ||= {}
  end

  attr_reader :guest_params

  private

  def convert
    convert_to_reservastion_params
    convert_to_guest_params
  end

  def convert_to_reservastion_params
    reservation[:code] = @payload[:reservation_code]
    %w[
      start_date
      end_date
      nights
      guests
      adults
      children
      infants
      status
      currency
      payout_price
      security_price
      total_price
    ].each { |attr| reservation[attr.to_sym] = @payload[attr] }
  end

  def convert_to_guest_params
    %w[email first_name last_name].each { |attr| guest[attr.to_sym] = @guest_payload[attr] }

    guest[:phone_numbers] = [@guest_payload[:phone]]
  end
end
