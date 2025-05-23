# typed: true
require 'yaml'
require_relative '../interfaces/web/helpers/http_helper'

module Services
  class OpenApiService
    def handle_request(env)
      case env['REQUEST_METHOD']
      when 'GET'
        handle_get_request(env)
      else
        Interfaces::Web::Helpers::HttpHelper.method_not_allowed
      end
    end

    private

    def handle_get_request(env)
      case env['SCRIPT_NAME']
      when '/openapi.yaml'
        serve_specification
      when '/docs'
        serve_swagger_ui
      else
        Interfaces::Web::Helpers::HttpHelper.not_found
      end
    end

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

    def serve_swagger_ui
      html = File.read('app/static/swagger-ui.html')
      headers = {
        'content-type' => 'text/html',
        'cache-control' => 'no-store, no-cache, must-revalidate, max-age=0',
        'pragma' => 'no-cache',
        'expires' => '0'
      }
      [200, headers, [html]]
    end
  end
end 