# typed: true
require 'bcrypt'
require_relative '../../infrastructure/services/jwt_service'

module Domain
  module UseCases
    class UserLogin
      def initialize(repository)
        @repository = repository
      end

      def execute(email:, password:)
        user = @repository.find_user_by_email(email)
        return { error: 'Invalid credentials' } unless user
        
        password_hash = BCrypt::Password.new(user.password_hash)
        return { error: 'Invalid credentials' } unless password_hash == password

        token = Infrastructure::Services::JwtService.encode(user_id: user.id)
        { token: token }
      end
    end
  end
end 