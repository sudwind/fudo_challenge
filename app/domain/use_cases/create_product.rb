# typed: true
require 'securerandom'

module Domain
  module UseCases
    class CreateProduct
      def initialize(repository)
        @repository = repository
      end

      def execute(name:)
        return { error: 'Product name is required and must be a non-empty string' } unless valid_name?(name)

        product = Domain::Models::Product.new(
          id: SecureRandom.uuid,
          name: name
        )

        # Create product in background
        Thread.new do
          # Sleep for 5 seconds before making the product available
          sleep 5
          @repository.create_product(product)
        end
      end

      private

      def valid_name?(name)
        name.is_a?(String) && !name.empty?
      end
    end
  end
end 