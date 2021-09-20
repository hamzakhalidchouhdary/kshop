module API
  module V1
    class Business_ < Grape::API
      before {authenticate_business_manager}

      resource :business do
        get "", root: :business do
          begin
            return {resource: 'business'}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end
      end
    end
  end
end