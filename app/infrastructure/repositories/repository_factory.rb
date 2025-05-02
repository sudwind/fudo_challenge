require_relative '../logger'

module Infrastructure
  module Repositories
    class RepositoryFactory
      def self.create_product_repository
        case ENV['USE_DATABASE']&.downcase
        when 'postgres'
          Infrastructure::Logger.logger.info("Using PostgreSQL repository")
          Infrastructure::Logger.logger.info("Database: #{ENV['POSTGRES_DB']}")
          Infrastructure::Logger.logger.info("Host: #{ENV['POSTGRES_HOST']}:#{ENV['POSTGRES_PORT']}")
          Infrastructure::Logger.logger.info("User: #{ENV['POSTGRES_USER']}")
          PostgresProductRepository.new
        else
          Infrastructure::Logger.logger.info("Using in-memory repository")
          Infrastructure::Logger.logger.info("Data will be stored in memory and will be lost when the server stops")
          InMemoryProductRepository.new
        end
      end
    end
  end
end 