# typed: true
require 'jwt'
require 'securerandom'

module Infrastructure
  module Services
    class JwtService
      ALGORITHM = 'HS256'
      EXPIRATION_TIME = 24 * 60 * 60 # 24 hours in seconds

      class << self
        def secret_key
          @secret_key ||= ENV['JWT_SECRET_KEY'] || SecureRandom.hex(32)
        end

        def encode(user_id)
          payload = {
            user_id: user_id,
            exp: Time.now.to_i + EXPIRATION_TIME
          }
          JWT.encode(payload, secret_key, ALGORITHM)
        end

        def decode(token)
          JWT.decode(token, secret_key, true, { algorithm: ALGORITHM })
        rescue JWT::DecodeError
          nil
        end
      end
    end
  end
end 