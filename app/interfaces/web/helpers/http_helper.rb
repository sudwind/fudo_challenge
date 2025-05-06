# typed: true
module Interfaces
  module Web
    module Helpers
      module HttpHelper
        def self.json_content_type
          { 'content-type' => 'application/json' }
        end

        def self.json_response(status, body)
          [status, json_content_type, [body.to_json]]
        end

        def self.error_response(status, message)
          json_response(status, { error: message })
        end

        def self.not_found
          error_response(404, 'Not found')
        end

        def self.method_not_allowed
          error_response(405, 'Method not allowed')
        end

        def self.bad_request(message = 'Invalid JSON')
          error_response(400, message)
        end

        def self.unauthorized
          error_response(401, 'Unauthorized')
        end

        def self.server_error(message)
          error_response(500, message)
        end

        def self.created(body)
          json_response(202, body)
        end

        def self.ok(body)
          json_response(200, body)
        end
      end
    end
  end
end 