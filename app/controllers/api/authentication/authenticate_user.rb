module API
  module Authentication
    class AuthenticateUser

      prepend SimpleCommand

      def initialize(username, password)
        @username = username
        @password = password
      end

      def call
        JsonWebToken.encode(user_id: user.id) if user
      end

      private

      attr_accessor :username, :password

      def user
        begin
          user = User.find_by_username(username)
          return user if user && user.authenticate(password)
          errors.add(:user_authentication, 'incorrect username or password')
          nil
        rescue Exception => e
          error!({error: e.message, status: 400, message: "something went wrong, Try later"})
        end
      end

    end
  end
end