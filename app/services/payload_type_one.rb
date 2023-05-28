# frozen_string_literal: true

class PayloadTypeOne
  def initialize(payload)
    @payload = payload[:reservation]
    @guest_payload = payload[:reservation]
    @params = {}
    @guest_params = {}
    convert
  end

  def params
    @params[:reservation][:guest_attributes] ||= guest_params
    @params
  end

  def reservation_params
    @params[:reservation] ||= {}
  end

  def guest_params
    @guest_params || {}
  end

  private

  def convert
    convert_to_reservastion_params
    convert_to_guest_params
  end

  def convert_to_reservastion_params
    %w[code start_date end_date nights].each { |attr| reservation_params[attr.to_sym] = @payload[attr] }

    if @payload[:guest_details]
      %w[adults children infants].each do |attr|
        reservation_params[attr.to_sym] = @payload[:guest_details]["number_of_#{attr}"]
      end
      reservation_params[:guests] = @payload[:guest_details][:localized_description]&.to_i
    end

    reservation_params[:status] = @payload[:status_type]
    reservation_params[:currency] = @payload[:host_currency]
    reservation_params[:payout_price] = @payload[:expected_payout_amount]
    reservation_params[:security_price] = @payload[:listing_security_price_accurate]
    reservation_params[:total_price] = @payload[:total_paid_amount_accurate]
  end

  def convert_to_guest_params
    %w[email first_name last_name phone_numbers].each do |attr|
      guest_params[attr] = @guest_payload["guest_#{attr}"]
    end

    guest_params[:id] = ::Guest.find_by_email(guest_params[:email])&.id
  end
end
