# a singleton jwt class 
class JsonWebToken
  class << self
    # encrypt user payload as jwt 
    def encode(payload, exp = 24.hours.from_now)
      # payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
    # decrypt user info from received token
    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end