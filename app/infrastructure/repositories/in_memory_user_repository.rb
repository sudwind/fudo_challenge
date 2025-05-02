# typed: true
module Infrastructure
  module Repositories
    class InMemoryUserRepository < Domain::Repositories::UserRepository
      def initialize
        @users = {}
      end

      def create(user)
        @users[user.id] = user
        user
      end

      def find_by_email(email)
        @users.values.find { |user| user.email == email }
      end
    end
  end
end 