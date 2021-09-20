module API
  class Base < Grape::API
    prefix 'api'
    
    mount API::V1::Base
  end
end