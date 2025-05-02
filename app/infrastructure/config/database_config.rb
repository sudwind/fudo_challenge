# typed: true
require_relative '../logger'

module Infrastructure
  module Config
    class DatabaseConfig
      def self.connection_params
        {
          dbname: ENV['POSTGRES_DB'] || 'products',
          user: ENV['POSTGRES_USER'] || 'postgres',
          password: ENV['POSTGRES_PASSWORD'] || 'postgres',
          host: ENV['POSTGRES_HOST'] || 'localhost',
          port: ENV['POSTGRES_PORT'] || 5432
        }
      end

      def self.log_connection_info
        Infrastructure::Logger.logger.info("Database: #{ENV['POSTGRES_DB']}")
        Infrastructure::Logger.logger.info("Host: #{ENV['POSTGRES_HOST']}:#{ENV['POSTGRES_PORT']}")
        Infrastructure::Logger.logger.info("User: #{ENV['POSTGRES_USER']}")
      end
    end
  end
end 