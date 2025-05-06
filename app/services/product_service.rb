# typed: true
require_relative 'parse_utils'
require_relative '../domain/use_cases/create_product'
require_relative '../domain/use_cases/search_products'
require_relative '../domain/use_cases/find_product'
require_relative '../domain/use_cases/list_products'

module Services
  class ProductService
    def initialize(create_product_use_case, search_products_use_case, find_product_use_case, list_products_use_case)
      @create_product_use_case = create_product_use_case
      @search_products_use_case = search_products_use_case
      @find_product_use_case = find_product_use_case
      @list_products_use_case = list_products_use_case
    end

    def create_product(request_body:)
      data = request_body.is_a?(String) ? Services::ParseUtils.parse_json(request_body) : request_body
      Services::ParseUtils.validate_required_fields(data, ['name'])
      
      @create_product_use_case.execute(name: data['name'])
    end

    def search_products(query_string:)
      query = Services::ParseUtils.parse_query_string(query_string)
      @search_products_use_case.execute(query: query)
    end

    def find_product(id:)
      @find_product_use_case.execute(id: id)
    end

    def list_products
      @list_products_use_case.execute
    end
  end
end 