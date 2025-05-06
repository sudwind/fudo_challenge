# typed: true
require_relative '../../../services/authors_service'

module Interfaces
  module Web
    module Controllers
      class AuthorsController
        def initialize
          @service = Services::AuthorsService.new
        end

        def call(env)
          @service.handle_request(env)
        end
      end
    end
  end
end 