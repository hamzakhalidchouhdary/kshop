module API
  module Authentication
    class AuthorizeApiRequest

      prepend SimpleCommand
      
      def initialize(headers = {}, user_type = '')
      @headers = headers
      @user_type = user_type
    end
    
    def call
      if @user_type === 'owner'
        owner
      elsif @user_type === 'business_manager'
        business_manager
      elsif @user_type === 'store_manager'
        store_manager
      elsif @user_type === 'account_manager'
        account_manager
      else
        owner
      end
    end
    
    private
    
    attr_reader :headers
    
      def owner
        if decoded_auth_token
          _user = User.find(@decoded_auth_token[:user_id]) 
          if _user && (_user.role.name === 'owner')
            @user ||= _user
          else
            @user || errors.add(:token, 'access denied') && nil
          end
        end
        @user || errors.add(:token, 'token expired') && nil
      end

      def business_manager
        if decoded_auth_token
          _owner = owner
          unless _owner
            _user = User.find(@decoded_auth_token[:user_id]) 
            if _user && (_user.staff.role.name === 'business manager')
              @user ||= _user
            else
              @user || errors.add(:token, 'access denied') && nil 
            end
          else
            @user ||= _owner
          end
        else
          @user ||= errors.add(:token, 'token expired') && nil
        end
      end

      def store_manager
        if decoded_auth_token
         _manager = business_manager
          unless _manager
            _user = User.find(@decoded_auth_token[:user_id]) 
            if _user && (_user.staff.role.name === 'store manager')
              @user ||= _user
            else
              @user || errors.add(:token, 'access denied') && nil 
            end
          else
            @user ||= _manager
          end
        else
          @user ||= errors.add(:token, 'token expired') && nil
        end
      end

      def account_manager
        if decoded_auth_token
         _manager = business_manager
          unless _manager
            _user = User.find(@decoded_auth_token[:user_id]) 
            if _user && (_user.staff.role.name === 'account manager')
              @user ||= _user
            else
              @user || errors.add(:token, 'access denied') && nil 
            end
          else
            @user ||= _manager
          end
        else
          @user ||= errors.add(:token, 'token expired') && nil
        end
      end

      def decoded_auth_token
        @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
      end

      def http_auth_header
        if headers['Authorization'].present?
          return headers['Authorization'].split(' ').last
        else
          errors.add(:token, 'missing token')
        end
        nil
      end
    end
  end
end