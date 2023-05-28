# frozen_string_literal: true

class PayloadTypeOne
  def initialize(payload)
    @payload = payload[:reservation]
    @guest_payload = payload[:reservation]
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
    %w[code start_date end_date nights].each { |attr| reservation[attr.to_sym] = @payload[attr] }

    if @payload[:guest_details]
      %w[adults children infants].each do |attr|
        reservation[attr.to_sym] = @payload[:guest_details]["number_of_#{attr}"]
      end
      reservation[:guests] = @payload[:guest_details][:localized_description]&.to_i
    end

    reservation[:status] = @payload[:status_type]
    reservation[:currency] = @payload[:host_currency]
    reservation[:payout_price] = @payload[:expected_payout_amount]
    reservation[:security_price] = @payload[:listing_security_price_accurate]
    reservation[:total_price] = @payload[:total_paid_amount_accurate]
  end

  def convert_to_guest_params
    %w[email first_name last_name phone_numbers].each do |attr|
      guest[attr] = @guest_payload["guest_#{attr}"]
    end
  end
end
