# typed: true
module Application
  module UseCases
    class SearchProducts
      def initialize(product_repository)
        @product_repository = product_repository
      end

      def execute(name: nil)
        @product_repository.search(name: name)
      end
    end
  end
end 