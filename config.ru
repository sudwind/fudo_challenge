# typed: true
require 'dotenv/load'
require 'json'
require 'securerandom'
require 'rack'
require 'rackup'
require 'jwt'
require 'bcrypt'
require_relative 'app/domain/models/product'
require_relative 'app/domain/models/user'
require_relative 'app/domain/repositories/repository'
require_relative 'app/application/use_cases/create_product'
require_relative 'app/application/use_cases/search_products'
require_relative 'app/application/use_cases/create_user'
require_relative 'app/infrastructure/repositories/in_memory_repository'
require_relative 'app/infrastructure/repositories/postgres_repository'
require_relative 'app/infrastructure/repositories/repository_factory'
require_relative 'app/infrastructure/services/jwt_service'
require_relative 'app/interfaces/web/controllers/products_controller'
require_relative 'app/interfaces/web/controllers/users_controller'
require_relative 'app/infrastructure/logger'

# Initialize repositories
repository = Infrastructure::Repositories::RepositoryFactory.create_repository

# Initialize use cases
create_product = Application::UseCases::CreateProduct.new(repository)
search_products = Application::UseCases::SearchProducts.new(repository)
create_user = Application::UseCases::CreateUser.new(repository)

# Initialize controllers
products_controller = Interfaces::Web::Controllers::ProductsController.new(create_product, search_products)
users_controller = Interfaces::Web::Controllers::UsersController.new(create_user)

# Define routes
app = Rack::Builder.new do
  use Rack::CommonLogger, Infrastructure::Logger.logger

  map '/products' do
    run products_controller
  end

  map '/users' do
    run users_controller
  end
end

run app