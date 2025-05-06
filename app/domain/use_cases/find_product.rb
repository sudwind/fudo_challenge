# typed: true
require_relative '../../infrastructure/services/logger_service'

module Domain
  module UseCases
    class FindProduct
      def initialize(repository)
        @repository = repository
      end

      def execute(id:)
        product = @repository.find_product(id)
        return { error: 'Product not found' } unless product
        
        Infrastructure::Services::LoggerService.logger.debug("Product found: #{product.inspect}")
        Infrastructure::Services::LoggerService.logger.debug("Product to_h: #{product.to_h.inspect}")
        
        { product: product.to_h }
      end
    end
  end
end 