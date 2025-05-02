# typed: true
require_relative '../logger'
require_relative '../../domain/repositories/repository'

module Infrastructure
  module Repositories
    class InMemoryRepository < Domain::Repositories::Repository
      def initialize
        Infrastructure::Logger.logger.info("Initializing in-memory repository...")
        @products = {}
        @users = {}
      end

      # Product methods
      def create_product(product)
        Infrastructure::Logger.logger.debug("Creating product: #{product.to_h}")
        @products[product.id] = product
        product
      end

      def find_product(id)
        Infrastructure::Logger.logger.debug("Finding product with id: #{id}")
        @products[id]
      end

      def all_products
        Infrastructure::Logger.logger.debug("Fetching all products")
        @products.values
      end

      def search_products(query)
        Infrastructure::Logger.logger.debug("Searching products with query: #{query}")
        @products.values.select { |product| product.name.downcase.include?(query.downcase) }
      end

      # User methods
      def create_user(user)
        Infrastructure::Logger.logger.debug("Creating user: #{user.to_h}")
        @users[user.id] = user
        user
      end

      def find_user(id)
        Infrastructure::Logger.logger.debug("Finding user with id: #{id}")
        @users[id]
      end

      def find_user_by_email(email)
        Infrastructure::Logger.logger.debug("Finding user with email: #{email}")
        @users.values.find { |user| user.email == email }
      end
    end
  end
end 