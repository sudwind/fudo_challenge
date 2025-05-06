# typed: true
require_relative 'parse_utils'
require_relative '../domain/use_cases/create_user'
require_relative '../domain/use_cases/user_login'

module Services
  class UserService
    def initialize(create_user_use_case, user_login_use_case)
      @create_user_use_case = create_user_use_case
      @user_login_use_case = user_login_use_case
    end

    def create_user(request_body:)
      data = parse_request_body(request_body)
      @create_user_use_case.execute(
        email: data['email'],
        password: data['password']
      )
    end

    def login_user(request_body:)
      Services::ParseUtils.validate_login_request(request_body)
      @user_login_use_case.execute(
        email: request_body['email'],
        password: request_body['password']
      )
    end

    private

    def parse_request_body(request_body)
      Services::ParseUtils.validate_required_fields(request_body, ['email', 'password'])
      request_body
    end
  end
end 