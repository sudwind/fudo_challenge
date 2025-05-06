# typed: true
require_relative '../services/logger_service'
require_relative '../config/database_config'

module Infrastructure
  module Repositories
    class RepositoryFactory
      class << self
        def create_repository
          case ENV['USE_DATABASE']&.downcase
          when 'postgres'
            ensure_postgres_logged
            PostgresRepository.new
          else
            ensure_in_memory_logged
            InMemoryRepository.new
          end
        end

        private

        def ensure_postgres_logged
          @postgres_logged ||= begin
            Infrastructure::Services::LoggerService.logger.info("Using PostgreSQL for data storage")
            Infrastructure::Config::DatabaseConfig.log_connection_info
            true
          end
        end

        def ensure_in_memory_logged
          @in_memory_logged ||= begin
            Infrastructure::Services::LoggerService.logger.info("Using in-memory storage - all data will be lost when the server stops")
            true
          end
        end
      end
    end
  end
end 