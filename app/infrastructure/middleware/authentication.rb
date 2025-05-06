# typed: true
module Infrastructure
  module Middleware
    class Authentication
      def initialize(app)
        @app = app
      end

      def call(env)
        auth_header = env['HTTP_AUTHORIZATION']
        
        if auth_header.nil? || !auth_header.start_with?('Bearer ')
          return unauthorized_response
        end

        token = auth_header.split(' ').last
        decoded_token = Infrastructure::Services::JwtService.decode(token)

        if decoded_token.nil?
          return unauthorized_response
        end

        # Add user_id to the environment for use in controllers
        env['user_id'] = decoded_token.first['user_id']
        @app.call(env)
      end

      private

      def unauthorized_response
        [401, { 'content-type' => 'application/json' }, [{ error: 'Unauthorized' }.to_json]]
      end
    end
  end
end 