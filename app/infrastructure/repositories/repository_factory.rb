require_relative '../logger'
require_relative '../config/database_config'

module Infrastructure
  module Repositories
    class RepositoryFactory
      def self.create_product_repository
        case ENV['USE_DATABASE']&.downcase
        when 'postgres'
          Infrastructure::Logger.logger.info("Using PostgreSQL repository for products")
          Infrastructure::Config::DatabaseConfig.log_connection_info
          PostgresProductRepository.new
        else
          Infrastructure::Logger.logger.info("Using in-memory repository for products")
          Infrastructure::Logger.logger.info("Data will be stored in memory and will be lost when the server stops")
          InMemoryProductRepository.new
        end
      end

      def self.create_user_repository
        case ENV['USE_DATABASE']&.downcase
        when 'postgres'
          Infrastructure::Logger.logger.info("Using PostgreSQL repository for users")
          Infrastructure::Config::DatabaseConfig.log_connection_info
          PostgresUserRepository.new
        else
          Infrastructure::Logger.logger.info("Using in-memory repository for users")
          Infrastructure::Logger.logger.info("Data will be stored in memory and will be lost when the server stops")
          InMemoryUserRepository.new
        end
      end
    end
  end
end 