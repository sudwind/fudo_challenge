# typed: true
require 'pg'
require_relative '../logger'
require_relative '../config/database_config'

module Infrastructure
  module Repositories
    class PostgresProductRepository < Domain::Repositories::ProductRepository
      def initialize
        Infrastructure::Logger.logger.info("Connecting to PostgreSQL database for products...")
        @connection = PG.connect(Infrastructure::Config::DatabaseConfig.connection_params)
        Infrastructure::Logger.logger.info("Successfully connected to PostgreSQL for products")
        create_table_if_not_exists
      end

      def create(product)
        Infrastructure::Logger.logger.debug("Creating product: #{product.to_h}")
        result = @connection.exec_params(
          'INSERT INTO products (id, name, description, price, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
          [product.id, product.name, product.description, product.price, product.created_at, product.updated_at]
        )
        map_result_to_product(result.first)
      end

      def find(id)
        Infrastructure::Logger.logger.debug("Finding product with id: #{id}")
        result = @connection.exec_params('SELECT * FROM products WHERE id = $1', [id])
        return nil if result.ntuples.zero?
        map_result_to_product(result.first)
      end

      def all
        Infrastructure::Logger.logger.debug("Fetching all products")
        result = @connection.exec('SELECT * FROM products')
        result.map { |row| map_result_to_product(row) }
      end

      def search(query)
        Infrastructure::Logger.logger.debug("Searching products with query: #{query}")
        result = @connection.exec_params(
          'SELECT * FROM products WHERE name ILIKE $1',
          ["%#{query}%"]
        )
        result.map { |row| map_result_to_product(row) }
      end

      private

      def create_table_if_not_exists
        Infrastructure::Logger.logger.info("Ensuring products table exists...")
        @connection.exec(<<-SQL)
          CREATE TABLE IF NOT EXISTS products (
            id UUID PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            description TEXT,
            price DECIMAL(10,2) NOT NULL,
            created_at TIMESTAMP NOT NULL,
            updated_at TIMESTAMP NOT NULL
          )
        SQL
        Infrastructure::Logger.logger.info("Products table ready")
      end

      def map_result_to_product(row)
        Domain::Models::Product.new(
          id: row['id'],
          name: row['name'],
          description: row['description'],
          price: row['price'].to_f,
          created_at: Time.parse(row['created_at']),
          updated_at: Time.parse(row['updated_at'])
        )
      end
    end
  end
end 