# typed: true
require 'bcrypt'

module Application
  module UseCases
    class UserLogin
      def initialize(repository)
        @repository = repository
      end

      def execute(email:, password:)
        # Find user by email
        user = @repository.find_user_by_email(email)
        return { error: 'Invalid email or password' } unless user

        # Verify password
        password_hash = BCrypt::Password.new(user.password_hash)
        return { error: 'Invalid email or password' } unless password_hash == password

        # Generate JWT token
        token = Infrastructure::Services::JwtService.encode(user.id)

        { email: user.email, token: token }
      end
    end
  end
end 