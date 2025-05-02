module Infrastructure
  module Repositories
    class InMemoryProductRepository < Domain::Repositories::ProductRepository
      def initialize
        @products = {}
      end

      def create(product)
        @products[product.id] = product
        product
      end

      def find(id)
        @products[id]
      end

      def all
        @products.values
      end

      def search(name: nil)
        if name.nil? || name.empty?
          all
        else
          all.select { |product| product.name.downcase.include?(name.downcase) }
        end
      end
    end
  end
end 