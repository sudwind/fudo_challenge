# typed: true
require 'json'
require_relative '../../../services/user_service'
require_relative '../../../services/parse_utils'
require_relative '../helpers/http_helper'

module Interfaces
  module Web
    module Controllers
      class UsersController
        def initialize(create_user_use_case, user_login_use_case)
          @service = Services::UserService.new(
            create_user_use_case,
            user_login_use_case
          )
        end

        def call(env)
          case env['REQUEST_METHOD']
          when 'POST'
            handle_post_request(env)
          else
            Helpers::HttpHelper.method_not_allowed
          end
        rescue ArgumentError => e
          Helpers::HttpHelper.bad_request(e.message)
        rescue => e
          Helpers::HttpHelper.server_error(e.message)
        end

        private

        def handle_post_request(env)
          case env['PATH_INFO']
          when '/create'
            handle_create_request(env)
          when '/login'
            handle_login_request(env)
          else
            Helpers::HttpHelper.not_found
          end
        end

        def handle_create_request(env)
          request_body = Services::ParseUtils.parse_rack_input(env)
          result = @service.create_user(request_body: request_body)

          if result[:error]
            Helpers::HttpHelper.bad_request(result[:error])
          else
            Helpers::HttpHelper.created(result)
          end
        end

        def handle_login_request(env)
          request_body = Services::ParseUtils.parse_rack_input(env)
          result = @service.login_user(request_body: request_body)

          if result[:error]
            Helpers::HttpHelper.unauthorized
          else
            Helpers::HttpHelper.ok(result)
          end
        end
      end
    end
  end
end 