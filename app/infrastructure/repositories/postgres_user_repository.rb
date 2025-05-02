# typed: true
require 'pg'
require_relative '../logger'
require_relative '../config/database_config'

module Infrastructure
  module Repositories
    class PostgresUserRepository < Domain::Repositories::UserRepository
      def initialize
        Infrastructure::Logger.logger.info("Connecting to PostgreSQL database for users...")
        @connection = PG.connect(Infrastructure::Config::DatabaseConfig.connection_params)
        Infrastructure::Logger.logger.info("Successfully connected to PostgreSQL for users")
        create_table_if_not_exists
      end

      def create(user)
        Infrastructure::Logger.logger.debug("Creating user: #{user.to_h}")
        result = @connection.exec_params(
          'INSERT INTO users (id, email, password_hash, created_at, updated_at) VALUES ($1, $2, $3, $4, $5) RETURNING *',
          [user.id, user.email, user.password_hash, user.created_at, user.updated_at]
        )
        map_result_to_user(result.first)
      end

      def find_by_email(email)
        Infrastructure::Logger.logger.debug("Finding user by email: #{email}")
        result = @connection.exec_params('SELECT * FROM users WHERE email = $1', [email])
        return nil if result.ntuples.zero?
        map_result_to_user(result.first)
      end

      private

      def create_table_if_not_exists
        Infrastructure::Logger.logger.info("Ensuring users table exists...")
        @connection.exec(<<-SQL)
          CREATE TABLE IF NOT EXISTS users (
            id UUID PRIMARY KEY,
            email VARCHAR(255) NOT NULL UNIQUE,
            password_hash VARCHAR(255) NOT NULL,
            created_at TIMESTAMP NOT NULL,
            updated_at TIMESTAMP NOT NULL
          )
        SQL
        Infrastructure::Logger.logger.info("Users table ready")
      end

      def map_result_to_user(row)
        Domain::Models::User.new(
          id: row['id'],
          email: row['email'],
          password_hash: row['password_hash'],
          created_at: Time.parse(row['created_at']),
          updated_at: Time.parse(row['updated_at'])
        )
      end
    end
  end
end 