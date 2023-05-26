class ReservationWithTypeOnePayload

  def initialize(params={})
    @permitted_params = Hash.new
  end

  def parameters
    @permitted_params
  end
end
