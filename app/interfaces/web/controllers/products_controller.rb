# typed: true
require 'json'
require_relative '../helpers/http_helper'

module Interfaces
  module Web
    module Controllers
      class ProductsController
        def initialize(create_product_use_case, search_products_use_case, find_product_use_case, list_products_use_case)
          @create_product_use_case = create_product_use_case
          @search_products_use_case = search_products_use_case
          @find_product_use_case = find_product_use_case
          @list_products_use_case = list_products_use_case
        end

        def create(env)
          request_body = JSON.parse(env['rack.input'].read)
          
          result = @create_product_use_case.execute(
            name: request_body['name']
          )

          if result[:error]
            Helpers::HttpHelper.bad_request(result[:error])
          else
            Helpers::HttpHelper.accepted(result)
          end
        rescue JSON::ParserError
          Helpers::HttpHelper.bad_request
        rescue => e
          Helpers::HttpHelper.server_error(e.message)
        end

        def search(env)
          query = Rack::Utils.parse_query(env['QUERY_STRING'])['q']
          result = @search_products_use_case.execute(query: query)
          Helpers::HttpHelper.ok(result)
        rescue => e
          Helpers::HttpHelper.server_error(e.message)
        end

        def find(env)
          id = env['PATH_INFO'].split('/').last
          result = @find_product_use_case.execute(id: id)
          Helpers::HttpHelper.ok(result)
        rescue PG::InvalidTextRepresentation
          Helpers::HttpHelper.bad_request('Invalid product ID format')
        rescue => _e
          Helpers::HttpHelper.server_error('An unexpected error occurred')
        end

        def index(_env)
          result = @list_products_use_case.execute
          Helpers::HttpHelper.ok(result)
        rescue => e
          Helpers::HttpHelper.server_error(e.message)
        end

        def call(env)
          case env['REQUEST_METHOD']
          when 'POST'
            create(env)
          when 'GET'
            if env['PATH_INFO'] == '/search'
              search(env)
            elsif env['PATH_INFO'] =~ %r{^/[0-9a-f-]+$}
              find(env)
            elsif env['PATH_INFO'] == '' || env['PATH_INFO'] == '/'
              index(env)
            else
              Helpers::HttpHelper.not_found
            end
          else
            Helpers::HttpHelper.method_not_allowed
          end
        end
      end
    end
  end
end 