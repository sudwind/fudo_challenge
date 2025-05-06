# typed: true
module UseCases
  class ListProducts
    def initialize(repository)
      @repository = repository
    end

    def execute
      products = @repository.all_products
      { products: products.map(&:to_h) }
    end
  end
end 