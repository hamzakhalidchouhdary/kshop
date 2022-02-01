module API
  module V1
    class Staff_ < Grape::API
      before {authenticate_business_manager}
      before {organization_active?}
      before {find_business}

      resource :staff do
        desc 'get staffs of business'
        get '', root: :staff do
          begin
            return {staff: @user_business.staffs, user: @current_user}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc 'get a staff of business'
        get ':staff_id', root: :staff do
          begin
            staff = find_staff
            return {staff: staff, payables: staff.staff_payments}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc 'create staff of business'
        params do
          requires :role_id, type: Integer, regexp: /\A[0-9]+\Z/
          requires :name, type: String, regexp: /\A[a-zA-Z ]+\Z/
          requires :phone_no, type: String, regexp: /\A(\+).[0-9]+\Z/
          requires :address, type: String, regexp: /\A[\w#\-\.,\/ ]+\Z/
          requires :salary, type: Float, regexp: /\A[0-9]+(\.)[0-9]+\Z/
        end
        post '', root: :staff do
          begin
            allowed_params = declared(params, include_missing: false)
            allowed_params[:salary_paid] = false
            allowed_params[:organization_id] = @user_business.organization_id
            staff = @user_business.staffs.new(allowed_params)
            return {staff: staff, message: 'staff has been created', status: 200} if staff.save
            return {message: 'can not create staff', status: 300}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc 'update staff information'
        params do
          optional :role_id, type: Integer, regexp: /\A[0-9]+\Z/
          optional :name, type: String, regexp: /\A[a-zA-Z ]+\Z/
          optional :phone_no, type: String, regexp: /\A(\+).[0-9]+\Z/
          optional :address, type: String, regexp: /\A[\w#\-\.,\/ ]+\Z/
          optional :salary, type: Float, regexp: /\A[0-9]+(\.)[0-9]+\Z/
        end
        put ':staff_id', root: :staff do
          begin
            allowed_params = declared(params, include_missing: false)
            staff = find_staff
            return {message: 'staff updated', status: 200} if staff.update(params)
            return {message: 'can not update staff', status: 500}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc 'update staff information'
        params do
        end
        post ':staff_id/paid', root: :staff do
          begin
            allowed_params = declared(params, include_missing: false)
            staff = find_staff
            return {message: 'salary status updated', status: 200} if staff.update(salary_paid: true)
            return {message: 'can not update salary status', status: 500}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end
        get 'user', root: :staff do
          begin
            return {users: @current_user.organization.users}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end
        
        desc 'create user'
        params do
          requires :staff_id, type: Integer, regexp: /\A[0-9]+\Z/
          requires :username, type: String, regexp: /\A[a-zA-Z0-9@_]+\Z/
          requires :password, type: String, regexp: /\A\w+\z/
        end
        post 'user', root: :staff do
          begin
            allowed_params = declared(params, include_missing: false)
            allowed_params[:organization_id] = @user_business.organization_id
            allowed_params[:role_id] = Staff.find_by(id: params[:staff_id]).role.id
            return {message: 'username already exisit', status: 500} if User.find_by_username(params[:username])
            user = User.new(allowed_params)
            return {user: user, message: 'user has been created', status: 200} if user.save
            return {message: 'can not create user', status: 300}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end
        
        desc 'delete a user'
        delete 'user/:user_id', root: :staff do
          begin
            user = @current_user.organization.users.find{|e| e.id == params[:user_id].to_i}
            return {message: 'user has been deleted', status: 200, user: user} if user.delete
            return {message: 'can not delete user', status: 300}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end 
        end

        desc 'delete all user'
        delete 'user', root: :staff do
          begin
            users = @current_user.organization.users
            return {message: 'user has been deleted', status: 200, users: users}
            return {message: 'can not delete user', status: 300}

          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end 
        end
      end
    end
  end
end