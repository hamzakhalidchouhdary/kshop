module API
  module V1
    class Admin < Grape::API
      resource :admin do 

        # role routes start
        desc "get role"
        params do
        end
        get "role", root: :admin do
          begin
            allowed_params = declared(params, include_missing: false)
            roles = Role.all
            return {roles: roles}
          rescue Exception => e
            error!({message: 'something went wrong, Try later', status: 400, error: e.message})
          end
        end

        desc "add role"
        params do
          requires :name, type: String, regexp: /\A[a-zA-Z ]+\Z/
        end
        post "role", root: :admin do
          begin
            allowed_params = declared(params, include_missing: false)
            roles = Role.new(allowed_params).save
            return {roles: roles, status: 200}
          rescue Exception => e
            error!({message: 'something went wrong, Try later', status: 400, error: e.message})
          end
        end
        desc "add role"
        params do
          requires :name, type: String, regexp: /\A[a-zA-Z ]+\Z/
        end
        put "role/:role_id", root: :admin do
          begin
            allowed_params = declared(params, include_missing: false)
            role = Role.find(params[:role_id])
            role.update(allowed_params);
            return {role: role, status: 200}
          rescue Exception => e
            error!({message: 'something went wrong, Try later', status: 400, error: e.message})
          end
        end
        # role routes end

        # package routes start
        desc "get package"
        params do
        end
        get "package", root: :admin do
          begin
            allowed_params = declared(params, include_missing: false)
            packages = Package.all
            return {packages: packages}
          rescue Exception => e
            error!({message: 'something went wrong, Try later', status: 400, error: e.message})
          end
        end

        desc "add package"
        params do
          requires :name, type: String, regexp: /\A[a-z]+\Z/
          requires :price, type: Integer, regexp: /\A[0-9]+\Z/
          requires :price_type, type: String, regexp: /\A[a-z]+\Z/
          requires :business_limit, type: Integer, regexp: /\A[0-9]+\Z/
        end
        post "package", root: :admin do
          begin
            allowed_params = declared(params, include_missing: false)
            return {message: "already exisits", status: 200} if Package.find_by_name(allowed_params[:name])
            package = Package.new(allowed_params).save
            return {package: package, status: 200}
          rescue Exception => e
            error!({error: e.message, message: 'something went wrong, Try later', status: 400})
          end
        end

        desc "update package"
        params do
          requires :name, type: String, regexp: /\A[a-z]+\Z/
          requires :price, type: Integer, regexp: /\A[0-9]+\Z/
          requires :price_type, type: String, regexp: /\A[a-z]+\Z/
          requires :business_limit, type: Integer, regexp: /\A[0-9]+\Z/
        end
        put "package", root: :admin do
          begin
            allowed_params = declared(params, include_missing: false)
            return {message: "does not exisits", status: 200} unless Package.find_by_name(allowed_params[:name])
            package = Package.find_by_name(allowed_params[:name])
            package.update(allowed_params)
            return {package: package, status: 200}
          rescue Exception => e
            error!({error: e.message, message: 'something went wrong, Try later', status: 400})
          end
        end

        # package routes end
      end
    end
  end
end