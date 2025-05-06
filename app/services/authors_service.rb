# typed: true
require_relative '../interfaces/web/helpers/http_helper'

module Services
  class AuthorsService
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
      if env['SCRIPT_NAME'] == '/AUTHORS'
        serve_authors
      else
        Interfaces::Web::Helpers::HttpHelper.not_found
      end
    end

    def serve_authors
      content = File.read('app/static/AUTHORS')
      headers = {
        'content-type' => 'text/plain',
        'cache-control' => 'public, max-age=86400', # 24 hours in seconds
        'expires' => (Time.now + 86400).httpdate
      }
      [200, headers, [content]]
    end
  end
end 