# typed: true
require 'sorbet-runtime'
require 'connection_pool'
require 'pg'
require_relative '../logger'
require_relative '../config/database_config'

module Infrastructure
  module Database
    class ConnectionManager
      class << self
        def connection_pool
          @connection_pool ||= ConnectionPool.new(size: pool_size, timeout: timeout) do
            PG.connect(Infrastructure::Config::DatabaseConfig.connection_params)
          end
        end

        def with_connection(&block)
          connection_pool.with do |conn|
            block.call(conn)
          end
        rescue PG::Error => e
          Infrastructure::Logger.logger.error("Database error: #{e.message}")
          raise
        end

        private

        def pool_size
          5
        end

        def timeout
          5
        end
      end
    end
  end
end 