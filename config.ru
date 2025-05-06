# typed: true
require 'dotenv/load'
require 'json'
require 'securerandom'
require 'rack'
require 'rackup'
require 'jwt'
require 'bcrypt'
require 'zlib'
require 'stringio'
require_relative 'app/domain/models/product'
require_relative 'app/domain/models/user'
require_relative 'app/domain/repositories/repository'
require_relative 'app/use_cases/create_product'
require_relative 'app/use_cases/search_products'
require_relative 'app/use_cases/find_product'
require_relative 'app/use_cases/list_products'
require_relative 'app/use_cases/create_user'
require_relative 'app/use_cases/user_login'
require_relative 'app/infrastructure/repositories/in_memory_repository'
require_relative 'app/infrastructure/repositories/postgres_repository'
require_relative 'app/infrastructure/repositories/repository_factory'
require_relative 'app/infrastructure/services/jwt_service'
require_relative 'app/infrastructure/middleware/authentication'
require_relative 'app/infrastructure/middleware/compression'
require_relative 'app/interfaces/web/controllers/products_controller'
require_relative 'app/interfaces/web/controllers/users_controller'
require_relative 'app/interfaces/web/controllers/openapi_controller'
require_relative 'app/interfaces/web/controllers/authors_controller'
require_relative 'app/infrastructure/logger'

# Initialize repositories
repository = Infrastructure::Repositories::RepositoryFactory.create_repository

# Initialize use cases
create_product = UseCases::CreateProduct.new(repository)
search_products = UseCases::SearchProducts.new(repository)
find_product = UseCases::FindProduct.new(repository)
list_products = UseCases::ListProducts.new(repository)
create_user = UseCases::CreateUser.new(repository)
user_login = UseCases::UserLogin.new(repository)

# Initialize controllers
products_controller = Interfaces::Web::Controllers::ProductsController.new(create_product, search_products, find_product, list_products)
users_controller = Interfaces::Web::Controllers::UsersController.new(create_user, user_login)
openapi_controller = Interfaces::Web::Controllers::OpenApiController.new
authors_controller = Interfaces::Web::Controllers::AuthorsController.new

# Define routes
app = Rack::Builder.new do
  use Rack::CommonLogger, Infrastructure::Logger.logger
  use Infrastructure::Middleware::Compression

  map '/openapi.yaml' do
    run openapi_controller
  end

  map '/AUTHORS' do
    run authors_controller
  end

  map '/products' do
    use Infrastructure::Middleware::Authentication
    run products_controller
  end

  map '/users' do
    run users_controller
  end
end

run app