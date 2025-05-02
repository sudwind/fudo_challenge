# typed: true
module Interfaces
  module Web
    module Controllers
      class UsersController
        def initialize(create_user_use_case)
          @create_user_use_case = create_user_use_case
        end

        def create(env)
          request_body = JSON.parse(env['rack.input'].read)
          
          result = @create_user_use_case.execute(
            email: request_body['email'],
            password: request_body['password']
          )

          if result[:error]
            [400, { 'content-type' => 'application/json' }, [result.to_json]]
          else
            [201, { 'content-type' => 'application/json' }, [result.to_json]]
          end
        rescue JSON::ParserError
          [400, { 'content-type' => 'application/json' }, [{ error: 'Invalid JSON' }.to_json]]
        rescue => e
          [500, { 'content-type' => 'application/json' }, [{ error: e.message }.to_json]]
        end
      end
    end
  end
end 