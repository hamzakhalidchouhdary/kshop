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
        resource 'organization/:organization_id' do
          desc "get organization"
          params do
          end
          get '',root: :admin do
            begin
              return {organization: Organization.find(params[:organization_id])}
            rescue Exception => e
              error!({message: 'something went wrong, Try later', status: 400, error: e.message})
            end
          end

          desc 'suspend organization'
          params do
          end
          post "suspend", root: :admin do
            begin
              org = Organization.find(params[:organization_id])
              return {status: 200, message: "organization has been suspended", org: org} if org.update(status:'suspended')
              return {status: 400, message: "can not change organization status", org: org}
            rescue Exception => e
              error!({message: 'something went wrong, Try later', status: 400, error: e.message})
            end
          end

          desc 'activate organization'
          params do
          end
          post "activate", root: :admin do
            begin
              org = Organization.find(params[:organization_id])
              return {status: 200, message: "organization has been activated", org: org} if org.update(status:'active')
              return {status: 400, message: "can not change organization status", org: org}
            rescue Exception => e
              error!({message: 'something went wrong, Try later', status: 400, error: e.message})
            end
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

        desc 'create offer type'
        params do
          requires :name, type: String, regexp: /\A[a-zA-Z ]+\Z/, allow_blank: {value: false, message: 'can not be empty'}
        end
        post '/offer_type', root: :admin do
          begin
            allowed_params = declared(params, include_missing: false, include_parants_params: false)
            return {offer_created: OfferType.new(allowed_params).save, status: 200}
          rescue Exception => e
            error!({error: e.message, message: 'something went wrong, Try later', status: 400})
          end
        end
      end
    end
  end
end