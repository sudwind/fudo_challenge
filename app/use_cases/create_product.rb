# typed: true
require 'securerandom'

module UseCases
  class CreateProduct
    def initialize(repository)
      @repository = repository
    end

    def execute(name:)
      Thread.new do
        product = Domain::Models::Product.new(
          id: SecureRandom.uuid,
          name: name
        )

        # Sleep for 5 seconds before making the product available
        sleep 5

        created_product = @repository.create_product(product)
        puts "Product created: #{created_product.to_h.to_json}"
      end
    end
  end
end 