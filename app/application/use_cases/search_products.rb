# typed: true
module Application
  module UseCases
    class SearchProducts
      def initialize(repository)
        @repository = repository
      end

      def execute(query = nil)
        if query.nil? || query.empty?
          @repository.all_products
        else
          @repository.search_products(query)
        end
      end
    end
  end
end 