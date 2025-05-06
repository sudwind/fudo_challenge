# typed: true
module Domain
  module Interfaces
    class Repository
      # Product methods
      def create_product(product)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def find_product(id)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def all_products
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def search_products(query)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      # User methods
      def create_user(user)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def find_user(id)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def find_user_by_email(email)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end
    end
  end
end 