# frozen_string_literal: true

class CreateReservation
  def initialize(params)
    @params = params
    @mapped_parametes = {}
  end

  def call
    map_with_type_one_payload if params[:reservation].present?
    map_with_type_two_payload if params[:reservation_code].present?
  end

  def map_with_type_one_payload; end

  def type_one_payload_mapping; end
end
