# typed: true
require 'jwt'

module Infrastructure
  module Services
    class JwtService
      SECRET_KEY = ENV['JWT_SECRET_KEY'] || 'your-secret-key'
      ALGORITHM = 'HS256'
      EXPIRATION_TIME = 24 * 60 * 60 # 24 hours in seconds

      def self.encode(user_id)
        payload = {
          user_id: user_id,
          exp: Time.now.to_i + EXPIRATION_TIME
        }
        JWT.encode(payload, SECRET_KEY, ALGORITHM)
      end

      def self.decode(token)
        JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })
      rescue JWT::DecodeError
        nil
      end
    end
  end
end 