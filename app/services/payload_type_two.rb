class PayloadTypeTwo

  def initialize(payload)
    @payload = payload
    @guest_payload = payload[:guest]
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
    reservation_params[:code] =  @payload[:reservation_code]
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
    ].each{ |attr| reservation_params[attr.to_sym] = @payload[attr] }
  end

  def convert_to_guest_params
    %w[email first_name last_name].each { |attr| guest_params[attr.to_sym] = @guest_payload[attr] }

    guest_params[:phone_numbers] = [@guest_payload[:phone]]
    guest_params[:id] = ::Guest.find_by_email(guest_params['email'])&.id
  end
end
