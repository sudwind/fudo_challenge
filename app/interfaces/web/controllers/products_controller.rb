module Interfaces
  module Web
    module Controllers
      class ProductsController
        def initialize(create_product_use_case, search_products_use_case)
          @create_product_use_case = create_product_use_case
          @search_products_use_case = search_products_use_case
        end

        def create(env)
          request_body = JSON.parse(env['rack.input'].read)
          
          # Start async process
          @create_product_use_case.execute(
            name: request_body['name'],
            description: request_body['description'],
            price: request_body['price']
          )

          # Return immediately
          [202, { 'content-type' => 'application/json' }, []]
        rescue JSON::ParserError
          [400, { 'content-type' => 'application/json' }, [{ error: 'Invalid JSON' }.to_json]]
        rescue => e
          [500, { 'content-type' => 'application/json' }, [{ error: e.message }.to_json]]
        end

        def search(env)
          params = Rack::Utils.parse_query(env['QUERY_STRING'])
          name = params['name']

          products = @search_products_use_case.execute(name: name)
          [200, { 'content-type' => 'application/json' }, [products.map(&:to_h).to_json]]
        end
      end
    end
  end
end 