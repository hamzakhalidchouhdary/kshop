module API
  module V1
    class Business_ < Grape::API
      before {authenticate_business_manager}
      before {organization_active?}
      before {find_business}

      resource :business do
        desc 'return user business'
        get "", root: :organization do
          begin
            return {business: @user_business}
          rescue Exception => e
            error!({message: 'something went wrong, Try later', status: 400, error: e.message})
          end
        end

        desc 'update business'
        params do
          requires :business_category_id, type: Integer, regexp: /\A[0-9]+\Z/
          requires :name, type: String, regexp: /\A[a-zA-Z ]+\Z/
          requires :address, type: String, regexp: /\A[\w#\-\.,\/ ]+\Z/
          requires :phone_no, type: String, regexp: /\A(\+).[0-9]+\Z/
          requires :email, type: String, regexp: /\A[a-zA-Z0-9._]+@[a-z]+\.[a-z]+\Z/
        end
        put ":business_id", root: :organization do
          begin
            business = find_business_by_id(params[:business_id])
            allowed_params = declared(params, include_missing: false)
            business.update(allowed_params)
            return {business: business, message: 'business has been updated', status: 200}
          rescue Exception => e
            error!({message: 'something went wrong, Try later', status: 400, error: e.message})
          end            
        end

        resource :offer do
          desc "get all offers"
          params do
          end
          get "", root: :offer do
            begin
              return {resource: 'offer'}
            rescue Exception => e
              error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
            end
          end

          desc "get a offer"
          params do
          end
          get ":offer_id", root: :offer do
            begin
              offer = find_offer
              return {offer: offer}
            rescue Exception => e
              error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
            end
          end

          desc "create offer"
          params do
            requires :offer_type_id, type: Integer, regexp: /\A[0-9]+\Z/
            requires :name, type: String, regexp: /\A[a-zA-Z ]+\Z/
            requires :discount, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
            requires :min_amount, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
            requires :end_on, type: DateTime, coerce_with: DateTime.method(:iso8601), allow_blank: { value: false, message: 'not selected' }
          end
          post '', root: :offer do
            begin
              allowed_params = declared(params, include_missing: false)
              offer = @user_business.offers.new(allowed_params)
              return {offer: offer, status: 200} if offer.save
              return {message: "can not create offer", status: 400}
            rescue Exception => e 
              error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
            end
          end

        end
      end
    end
  end
end