require 'securerandom'
require 'bcrypt'

module Application
  module UseCases
    class CreateUser
      def initialize(user_repository)
        @user_repository = user_repository
      end

      def execute(email:, password:)
        # Check if user already exists
        existing_user = @user_repository.find_by_email(email)
        return { error: 'User already exists' } if existing_user

        # Create new user
        password_hash = BCrypt::Password.create(password)
        user = Domain::Models::User.new(
          id: SecureRandom.uuid,
          email: email,
          password_hash: password_hash
        )

        created_user = @user_repository.create(user)
        token = Infrastructure::Services::JwtService.encode(created_user.id)

        { user: created_user.to_h, token: token }
      end
    end
  end
end 