# typed: true
require 'securerandom'
require 'bcrypt'

module UseCases
  class CreateUser
    def initialize(repository)
      @repository = repository
    end

    def execute(email:, password:)
      # Check if user already exists
      existing_user = @repository.find_user_by_email(email)
      return { error: 'User already exists' } if existing_user

      # Create new user
      password_hash = BCrypt::Password.create(password)
      user = Domain::Models::User.new(
        id: SecureRandom.uuid,
        email: email,
        password_hash: password_hash
      )

      @repository.create_user(user)
      { message: 'User created successfully' }
    end
  end
end 