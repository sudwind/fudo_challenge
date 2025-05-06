# typed: true
require_relative '../services/logger_service'
require_relative '../../domain/interfaces/repository'

module Infrastructure
  module Repositories
    class InMemoryRepository < Domain::Interfaces::Repository
      def initialize
        Infrastructure::Services::LoggerService.logger.info("Initializing in-memory repository...")
        @products = {}
        @users = {}
      end

      # Product methods
      def create_product(product)
        Infrastructure::Services::LoggerService.logger.debug("Creating product: #{product.to_h}")
        @products[product.id] = product
      end

      def find_product(id)
        Infrastructure::Services::LoggerService.logger.debug("Finding product with id: #{id}")
        @products[id]
      end

      def all_products
        Infrastructure::Services::LoggerService.logger.debug("Fetching all products")
        @products.values
      end

      def search_products(query)
        Infrastructure::Services::LoggerService.logger.debug("Searching products with query: #{query}")
        @products.values.select { |product| product.name.downcase.include?(query.downcase) }
      end

      # User methods
      def create_user(user)
        Infrastructure::Services::LoggerService.logger.debug("Creating user: #{user.to_h}")
        @users[user.id] = user
        user
      end

      def find_user(id)
        Infrastructure::Services::LoggerService.logger.debug("Finding user with id: #{id}")
        @users[id]
      end

      def find_user_by_email(email)
        Infrastructure::Services::LoggerService.logger.debug("Finding user with email: #{email}")
        @users.values.find { |user| user.email == email }
      end
    end
  end
end 