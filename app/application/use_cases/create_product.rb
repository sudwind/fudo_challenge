# typed: true
module Application
  module UseCases
    class CreateProduct
      def initialize(product_repository)
        @product_repository = product_repository
      end

      def execute(name:, description:, price:)
        Thread.new do
          product = Domain::Models::Product.new(
            id: SecureRandom.uuid,
            name: name,
            description: description,
            price: price
          )

          created_product = @product_repository.create(product)
          puts "Product created: #{created_product.to_h.to_json}"
        end
      end
    end
  end
end 