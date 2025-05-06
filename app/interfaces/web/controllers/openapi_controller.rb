# typed: true
require_relative '../../../services/openapi_service'

module Interfaces
  module Web
    module Controllers
      class OpenApiController
        def initialize
          @service = Services::OpenApiService.new
        end

        def call(env)
          @service.handle_request(env)
        end
      end
    end
  end
end 