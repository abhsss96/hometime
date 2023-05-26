module Api
  module V1
    class Root < Grape::API
      format :json
      mount Api::V1::Resources::Reservations
    end
  end
end
