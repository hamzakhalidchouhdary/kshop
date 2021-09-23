module API
  module V1
    module Helper
      extend ActiveSupport::Concern

      def generate_jwt
        begin
          command = Authentication::AuthenticateUser.call(params[:username], params[:password])
          if command.success?
            @auth_token = command.result
          else
            error!({error: command.errors[:user_authentication][0], status: 400})
          end
        rescue Exception => e
          error!({error: e.message, status: 400, message: 'something went wrong, Try later'})
        end
      end

      def authenticate
        begin
          command = Authentication::AuthorizeApiRequest.call(request.headers)
          @current_user = command.result
          error!({error: command.errors[:token][0], status: 400}) unless @current_user
        rescue Exception => e
          error!({error: e.message, status: 400, message: 'something went wrong, Try later'})
        end
      end

      def authenticate_owner
        begin
          command = Command::AuthorizeApiRequest.call(request.headers, "owner")
          @current_user = command.result
          error!({error: command.errors[:token][0], status: 400}) unless @current_user
        rescue Exception => e
          error!({error: e.message, status: 400, message: 'something went wrong, Try later'})
        end
      end

      def authenticate_business_manager
        begin
          command = Authentication::AuthorizeApiRequest.call(request.headers, 'business_manager')
          @current_user = command.result
          error!({error: command.errors[:token][0], status: 400}) unless @current_user
        rescue Exception => e
          error!({error: e.message, status: 400, message: 'something went wrong, Try later'})
        end
      end

      def authenticate_store_manager
        begin
          command = Authentication::AuthorizeApiRequest.call(request.headers, 'store_manager')
          @current_user = command.result
          error!({error: command.errors[:token][0], status: 400}) unless @current_user
        rescue Exception => e
          error!({error: e.message, status: 400, message: 'something went wrong, Try later'})
        end
      end

      def authenticate_account_manager
        begin
          command = Authentication::AuthorizeApiRequest.call(request.headers, 'account_manager')
          @current_user = command.result
          error!({error: command.errors[:token][0], status: 400}) unless @current_user
        rescue Exception => e
          error!({error: e.message, status: 400, message: 'something went wrong, Try later'})
        end
      end

      def find_business
        begin
          if params[:business_id].present?
            @user_business = @current_user.organization.businesses.find{|e| e.id == params[:business_id].to_i}
          else
            @user_business = @current_user.staff.business if @current_user.staff
          end
          error!({error: 'business not found', status: 400}) unless @user_business
          return @user_business
        rescue Exception => e
          error!({error: e.message, status: 400, message: 'something went wrong, Try later'})
        end
      end

      def find_product
        begin
          product = @user_business.products.find{|e| e.id == params[:product_id].to_i}
          error!({error: 'product not found', status: 400}) unless product
          return product
        rescue Exception => e
          error!({error: e.message, status: 400, message: 'something went wrong, Try later'})
        end
      end

      def find_order
        begin
          order = @user_business.orders.find{|e| e.id == params[:order_id].to_i}
          error!({error: 'order not found', status: 400}) unless order
          return order
        rescue Exception => e
          error!({error: e.message, status: 400, message: 'something went wrong, Try later'})
        end
      end

      def find_return
        begin
          order = find_order
          order_return = order.returns.find{|e| e.id == params[:return_id].to_i}
          error!({error: 'return not found', status: 400}) unless order_return
          return order_return
        rescue Exception => e
          error!({error: e.message, status: 400, message: 'something went wrong, Try later'})
        end
      end

      def find_staff
        begin
          staff = @user_business.staffs.find{|e| e.id == params[:staff_id].to_i}
          error!({error: 'staff not found', status: 400}) unless staff
          return staff
        rescue Exception => e
          error!({error: e.message, status: 400, message: 'something went wrong, Try later'})
        end
      end

      def organization_exisit?
        error!({error: 'no organization found', status: 400}) unless @current_user.organization
        nil
      end

      def organization_exisit!
        error!({
          error: 'already exisit', 
          status: 400
        }) if @current_user.organization
        nil
      end

      def organization_active?
        error!({error: 'account suspended', status:400}) unless @current_user.organization.status == 'active'
        nil 
      end

      def business_limit!
        error!( {
          warning: 'limit reached',
          business_limit: @current_user.organization.business_limit,
          business_count: @current_user.organization.businesses.count,
          status: 500
        }) unless @current_user.organization.businesses.count < @current_user.organization.business_limit
        nil
      end
    end
  end
end