# typed: true

module Interfaces
  module Web
    module Controllers
      class AuthorsController
        def call(env)
          case env['REQUEST_METHOD']
          when 'GET'
            if env['SCRIPT_NAME'] == '/AUTHORS'
              serve_authors
            else
              [404, { 'content-type' => 'application/json' }, [{ error: 'Not found' }.to_json]]
            end
          else
            [405, { 'content-type' => 'application/json' }, [{ error: 'Method not allowed' }.to_json]]
          end
        end

        private

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
  end
end 