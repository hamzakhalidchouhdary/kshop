module API
  module V1
    class Organization_ < Grape::API
      before { authenticate }
      before {organization_active?}

      resource :organization do
        desc 'Get Organization'
        params do
        end
        get "", root: :organization do
          begin
            allowed_params = declared(params, include_missing: false)
            return {
              organization: @current_user.organization,
              businesses: @current_user.organization.businesses,
              staffs: @current_user.organization.staffs,
              payable: @current_user.organization.organization_payments
            }
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc 'Create Organization'
        params do
          requires :name, type: String, regexp: /\A[a-zA-Z ]+\Z/
          requires :address, type: String, regexp: /\A[\w#\-\.,\/ ]+\Z/
          requires :owned_by, type: String, regexp: /\A[a-zA-Z ]+\Z/
          requires :phone_no, type: String, regexp: /\A(\+).[0-9]+\Z/
          requires :email, type: String, regexp: /\A[a-zA-Z0-9._]+@[a-z]+\.[a-z]+\Z/
          requires :package, type: String, regexp: /\A[a-z]+\Z/
        end
        post "", root: :organization do
          begin
            organization_exisit! # if exisit return error
            allowed_params = declared(params, include_missing: false)
            package = Package.find_by_name(allowed_params[:package])
            allowed_params[:package_price] = package.price
            allowed_params[:package_id] = package.id
            allowed_params[:business_limit] = package.business_limit
            allowed_params[:status] = 'active'
            org = Organization.new(allowed_params.except(:package))
            org.save
            @current_user.update(organization_id: org.id)
            return {message: 'Organization has been created', status: 200, data: @current_user.organization}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc 'update Organization'
        params do
          requires :name, type: String, regexp: /\A[a-zA-Z ]+\Z/
          requires :address, type: String, regexp: /\A[\w#\-\.,\/ ]+\Z/
          requires :owned_by, type: String, regexp: /\A[a-zA-Z ]+\Z/
          requires :phone_no, type: String, regexp: /\A(\+).[0-9]+\Z/
          requires :email, type: String, regexp: /\A[a-zA-Z0-9._]+@[a-z]+\.[a-z]+\Z/
        end
        put "", root: :organization do
          begin
            organization_exisit? # if not exisit return error
            allowed_params = declared(params, include_missing: false)
            @current_user.organization.update(allowed_params)
            return {message: 'Organization has been updated', status: 200, data: @current_user.organization}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc 'delete Organization'
        params do
        end
        delete "", root: :organization do
          begin
            organization_exisit? # if not exisit return error
            allowed_params = declared(params, include_missing: false)
            @current_user.organization.delete
            return {message: 'Organization has been deleted', status: 200}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        # business routes start
        desc 'return all business'
        get "business", root: :organization do
          begin
            return {business: @current_user.organization.businesses}
          rescue Exception => e
            error!({message: 'something went wrong, Try later', status: 400, error: e.message})
          end
        end

        desc 'return specified business'
        get "business/:business_id", root: :organization do
          begin
            return {business: find_business}
          rescue Exception => e
            error!({message: 'something went wrong, Try later', status: 400, error: e.message})
          end
        end

        desc 'create new business'
        params do
          requires :business_category_id, type: Integer, regexp: /\A[0-9]+\Z/
          requires :name, type: String, regexp: /\A[a-zA-Z ]+\Z/
          requires :address, type: String, regexp: /\A[\w#\-\.,\/ ]+\Z/
          requires :phone_no, type: String, regexp: /\A(\+).[0-9]+\Z/
          requires :email, type: String, regexp: /\A[a-zA-Z0-9._]+@[a-z]+\.[a-z]+\Z/
        end
        post "business", root: :organization do
          begin
            business_limit!
            allowed_params = declared(params, include_missing: false)
            new_business = @current_user.organization.businesses.new(allowed_params)
            return {business: new_business, message: 'business has been created', status: 200} if new_business.save
            return {message: 'can not created business', status: 500}
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
        put "business/:business_id", root: :organization do
          begin
            business = find_business_by_id(params[:business_id])
            allowed_params = declared(params, include_missing: false)
            business.update(allowed_params)
            return {business: business, message: 'business has been updated', status: 200}
          rescue Exception => e
            error!({message: 'something went wrong, Try later', status: 400, error: e.message})
          end            
        end

        desc 'delete a business'
        params do
        end
        delete "business/:business_id", root: :organization do
          begin
            business = find_business_by_id(params[:business_id])
            business.delete
            return {message: 'business has been deleted', status: 200}
          rescue Exception => e
            error!({message: 'something went wrong, Try later', status: 400, error: e.message})
          end            
        end

        desc 'delete all business'
        params do
        end
        delete "business/", root: :organization do
          begin
            @current_user.organization.businesses.delete_all
            return {message: 'business have been deleted', status: 200}
          rescue Exception => e
            error!({message: 'something went wrong, Try later', status: 400, error: e.message})
          end            
        end

        # business routes end
      end
    end
  end
end