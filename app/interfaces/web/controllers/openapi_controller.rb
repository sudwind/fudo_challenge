# typed: true
require 'yaml'

module Interfaces
  module Web
    module Controllers
      class OpenApiController
        def call(env)
          case env['REQUEST_METHOD']
          when 'GET'
            if env['SCRIPT_NAME'] == '/openapi.yaml'
              serve_specification
            else
              [404, { 'content-type' => 'application/json' }, [{ error: 'Not found' }.to_json]]
            end
          else
            [405, { 'content-type' => 'application/json' }, [{ error: 'Method not allowed' }.to_json]]
          end
        end

        private

        def serve_specification
          spec = YAML.load_file('app/static/openapi.yaml')
          headers = {
            'content-type' => 'application/x-yaml',
            'cache-control' => 'no-store, no-cache, must-revalidate, max-age=0',
            'pragma' => 'no-cache',
            'expires' => '0'
          }
          [200, headers, [spec.to_yaml]]
        end
      end
    end
  end
end 