module API
  module V1
    class Base < Grape::API
      helpers V1::Helper
      version 'v1'
      format :json

      mount V1::Admin
      mount V1::Organization_
      mount V1::User_
      mount V1::Business_
      mount V1::Staff_
      mount V1::Product_
    end
  end
end