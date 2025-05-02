# typed: true
module Domain
  module Repositories
    class ProductRepository
      def create(product)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def find(id)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def all
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def search(name: nil)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end
    end
  end
end 