# typed: true
module UseCases
  class FindProduct
    def initialize(repository)
      @repository = repository
    end

    def execute(id:)
      product = @repository.find_product(id)
      return { error: 'Product not found' } unless product
      { product: product.to_h }
    end
  end
end 