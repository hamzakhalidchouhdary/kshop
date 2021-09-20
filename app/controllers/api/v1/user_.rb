module API
  module V1
    class User_ < Grape::API
      resource :user do

        get '', root: :user do
          return {users: User.all}
        end

        desc 'user login'
        params do
          requires :username, type: String, regexp: /\A[a-zA-Z0-9@_]+\Z/
          requires :password, type: String, regexp: /\A\w+\z/
        end
        post "login", root: :user do
          begin
            allowed_params = declared(params, include_missing: false)
            generate_jwt
            return {user: {
              token: @auth_token,
              role: User.find_by_username(allowed_params[:username]).role.name
            }}
          rescue Exception => e
            error!({message: 'something went wrong, Try later', status: 400, error: e.message})
          end
        end

        desc 'user signin'
        params do
          requires :username, type: String, regexp: /\A[a-zA-Z0-9@_]+\Z/
          requires :password, type: String, regexp: /\A\w+\z/
        end
        post "signin", root: :user do
          begin
            allowed_params = declared(params, include_missing: false)
            allowed_params[:role_id] = Role.find_by(name: 'owner').id
            user = User.new(allowed_params).save
            # user = User.inspect
            return {message: 'user has been created', params: allowed_params, user: user}
          rescue Exception => e
            error!({message: 'something went wrong, Try later', status: 400, error: e.message})
          end
        end
      end
    end
  end
end