# typed: true
require 'json'
require_relative '../../../services/product_service'
require_relative '../../../services/parse_utils'
require_relative '../helpers/http_helper'

module Interfaces
  module Web
    module Controllers
      class ProductsController
        def initialize(create_product_use_case, search_products_use_case, find_product_use_case, list_products_use_case)
          @service = Services::ProductService.new(
            create_product_use_case,
            search_products_use_case,
            find_product_use_case,
            list_products_use_case
          )
        end

        def call(env)
          case env['REQUEST_METHOD']
          when 'GET'
            handle_get_request(env)
          when 'POST'
            handle_post_request(env)
          else
            Helpers::HttpHelper.method_not_allowed
          end
        rescue JSON::ParserError
          Helpers::HttpHelper.bad_request('Invalid JSON format')
        rescue => e
          Helpers::HttpHelper.server_error(e.message)
        end

        private

        def handle_get_request(env)
          case env['PATH_INFO']
          when '/search'
            handle_search_request(env)
          when ->(path) { Services::ParseUtils.is_uuid_path?(path) }
            handle_find_request(env)
          when '/', ""
            handle_list_request
          else
            Helpers::HttpHelper.not_found
          end
        end

        def handle_post_request(env)
          case env['PATH_INFO']
          when '/', ""
            handle_create_request(env)
          else
            Helpers::HttpHelper.not_found
          end
        end

        def handle_create_request(env)
          request_body = Services::ParseUtils.parse_rack_input(env)
          @service.create_product(request_body: request_body)
          Helpers::HttpHelper.accepted
        end

        def handle_search_request(env)
          result = @service.search_products(query_string: env['QUERY_STRING'])

          if result[:error]
            Helpers::HttpHelper.bad_request(result[:error])
          else
            Helpers::HttpHelper.ok(result)
          end
        end

        def handle_find_request(env)
          id = Services::ParseUtils.extract_id_from_path(env['PATH_INFO'])
          result = @service.find_product(id: id)

          if result[:error]
            Helpers::HttpHelper.not_found
          else
            Helpers::HttpHelper.ok(result)
          end
        end

        def handle_list_request
          result = @service.list_products

          if result[:error]
            Helpers::HttpHelper.bad_request(result[:error])
          else
            Helpers::HttpHelper.ok(result)
          end
        end
      end
    end
  end
end 