# typed: true
module UseCases
  class SearchProducts
    def initialize(repository)
      @repository = repository
    end

    def execute(query:)
      products = @repository.search_products(query)
      { products: products.map(&:to_h) }
    end
  end
end 