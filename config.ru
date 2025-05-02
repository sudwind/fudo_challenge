require 'dotenv/load'
require 'json'
require 'securerandom'
require 'rack'
require_relative 'app/domain/models/product'
require_relative 'app/domain/models/user'
require_relative 'app/domain/repositories/product_repository'
require_relative 'app/domain/repositories/user_repository'
require_relative 'app/application/use_cases/create_product'
require_relative 'app/application/use_cases/search_products'
require_relative 'app/application/use_cases/create_user'
require_relative 'app/infrastructure/repositories/in_memory_product_repository'
require_relative 'app/infrastructure/repositories/in_memory_user_repository'
require_relative 'app/infrastructure/repositories/postgres_product_repository'
require_relative 'app/infrastructure/repositories/repository_factory'
require_relative 'app/infrastructure/services/jwt_service'
require_relative 'app/interfaces/web/controllers/products_controller'
require_relative 'app/interfaces/web/controllers/users_controller'

# Initialize dependencies
product_repository = Infrastructure::Repositories::RepositoryFactory.create_product_repository
user_repository = Infrastructure::Repositories::InMemoryUserRepository.new
create_product_use_case = Application::UseCases::CreateProduct.new(product_repository)
search_products_use_case = Application::UseCases::SearchProducts.new(product_repository)
create_user_use_case = Application::UseCases::CreateUser.new(user_repository)
products_controller = Interfaces::Web::Controllers::ProductsController.new(create_product_use_case, search_products_use_case)
users_controller = Interfaces::Web::Controllers::UsersController.new(create_user_use_case)

# Define routes
app = lambda do |env|
  case env['PATH_INFO']
  when '/products'
    case env['REQUEST_METHOD']
    when 'POST'
      products_controller.create(env)
    when 'GET'
      products_controller.search(env)
    else
      [405, { 'content-type' => 'application/json' }, [{ error: 'Method not allowed' }.to_json]]
    end
  when '/users'
    case env['REQUEST_METHOD']
    when 'POST'
      users_controller.create(env)
    else
      [405, { 'content-type' => 'application/json' }, [{ error: 'Method not allowed' }.to_json]]
    end
  else
    [404, { 'content-type' => 'application/json' }, [{ error: 'Not found' }.to_json]]
  end
end

run app