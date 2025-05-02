module Domain
  module Repositories
    class UserRepository
      def create(user)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def find_by_email(email)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end
    end
  end
end 