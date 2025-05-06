# typed: true
require 'pg'
require_relative '../services/logger_service'
require_relative '../config/database_config'
require_relative '../database/connection_manager'
require_relative '../../domain/interfaces/repository'

module Infrastructure
  module Repositories
    class PostgresRepository < Domain::Interfaces::Repository
      def initialize
        Infrastructure::Services::LoggerService.logger.info("Initializing PostgreSQL repository...")
        create_tables_if_not_exist
      end

      # Product methods
      def create_product(product)
        Infrastructure::Services::LoggerService.logger.debug("Creating product: #{product.to_h}")
        Infrastructure::Database::ConnectionManager.with_connection do |conn|
          conn.exec_params(
            'INSERT INTO products (id, name) VALUES ($1, $2)',
            [product.id, product.name]
          )
        end
      end

      def find_product(id)
        Infrastructure::Services::LoggerService.logger.debug("Finding product with id: #{id}")
        Infrastructure::Database::ConnectionManager.with_connection do |conn|
          result = conn.exec_params('SELECT * FROM products WHERE id = $1', [id])
          return nil if result.ntuples.zero?
          map_result_to_product(result.first)
        end
      end

      def all_products
        Infrastructure::Services::LoggerService.logger.debug("Fetching all products")
        Infrastructure::Database::ConnectionManager.with_connection do |conn|
          result = conn.exec('SELECT * FROM products')
          result.map { |row| map_result_to_product(row) }
        end
      end

      def search_products(query)
        Infrastructure::Services::LoggerService.logger.debug("Searching products with query: #{query}")
        Infrastructure::Database::ConnectionManager.with_connection do |conn|
          result = conn.exec_params(
            'SELECT * FROM products WHERE name ILIKE $1',
            ["%#{query}%"]
          )
          result.map { |row| map_result_to_product(row) }
        end
      end

      # User methods
      def create_user(user)
        Infrastructure::Services::LoggerService.logger.debug("Creating user: #{user.to_h}")
        Infrastructure::Database::ConnectionManager.with_connection do |conn|
          result = conn.exec_params(
            'INSERT INTO users (id, email, password_hash, created_at, updated_at) VALUES ($1, $2, $3, $4, $5) RETURNING *',
            [user.id, user.email, user.password_hash, user.created_at, user.updated_at]
          )
          map_result_to_user(result.first)
        end
      end

      def find_user(id)
        Infrastructure::Services::LoggerService.logger.debug("Finding user with id: #{id}")
        Infrastructure::Database::ConnectionManager.with_connection do |conn|
          result = conn.exec_params('SELECT * FROM users WHERE id = $1', [id])
          return nil if result.ntuples.zero?
          map_result_to_user(result.first)
        end
      end

      def find_user_by_email(email)
        Infrastructure::Services::LoggerService.logger.debug("Finding user with email: #{email}")
        Infrastructure::Database::ConnectionManager.with_connection do |conn|
          result = conn.exec_params('SELECT * FROM users WHERE email = $1', [email])
          return nil if result.ntuples.zero?
          map_result_to_user(result.first)
        end
      end

      private

      def create_tables_if_not_exist
        Infrastructure::Services::LoggerService.logger.info("Ensuring database tables exist...")
        Infrastructure::Database::ConnectionManager.with_connection do |conn|
          conn.exec(<<-SQL)
            CREATE TABLE IF NOT EXISTS products (
              id UUID PRIMARY KEY,
              name VARCHAR(255) NOT NULL
            );

            CREATE TABLE IF NOT EXISTS users (
              id UUID PRIMARY KEY,
              email VARCHAR(255) NOT NULL UNIQUE,
              password_hash VARCHAR(255) NOT NULL,
              created_at TIMESTAMP NOT NULL,
              updated_at TIMESTAMP NOT NULL
            );
          SQL
        end
        Infrastructure::Services::LoggerService.logger.info("Database tables ready")
      end

      def map_result_to_product(row)
        Domain::Models::Product.new(
          id: row['id'],
          name: row['name']
        )
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