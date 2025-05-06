# typed: true
require_relative '../services/logger_service'

module Infrastructure
  module Config
    class DatabaseConfig
      def self.connection_params
        {
          dbname: ENV['POSTGRES_DB'] || 'postgres',
          user: ENV['POSTGRES_USER'] || 'postgres',
          password: ENV['POSTGRES_PASSWORD'] || 'postgres',
          host: ENV['POSTGRES_HOST'] || 'localhost',
          port: ENV['POSTGRES_PORT'] || 5432
        }
      end

      def self.log_connection_info
        Infrastructure::Services::LoggerService.logger.info("Database: #{ENV['POSTGRES_DB']}")
        Infrastructure::Services::LoggerService.logger.info("Host: #{ENV['POSTGRES_HOST']}:#{ENV['POSTGRES_PORT']}")
        Infrastructure::Services::LoggerService.logger.info("User: #{ENV['POSTGRES_USER']}")
      end
    end
  end
end 