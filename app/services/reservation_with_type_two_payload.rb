class ReservationWithTypeOnePayload
  def initialize(_params = {})
    @permitted_params = {}
  end

  def parameters
    @permitted_params
  end
end
