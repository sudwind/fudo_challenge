require 'bundler/setup'
require 'dotenv/load'
require 'rspec'
require 'rack/test'
require 'factory_bot'
require 'faker'
require 'json'
require 'securerandom'
require 'jwt'
require 'bcrypt'
require 'database_cleaner/active_record'

# Load application files
require_relative '../app/domain/models/product'
require_relative '../app/domain/models/user'
require_relative '../app/domain/interfaces/repository'
require_relative '../app/domain/use_cases/create_product'
require_relative '../app/domain/use_cases/search_products'
require_relative '../app/domain/use_cases/find_product'
require_relative '../app/domain/use_cases/list_products'
require_relative '../app/domain/use_cases/create_user'
require_relative '../app/domain/use_cases/user_login'
require_relative '../app/infrastructure/repositories/in_memory_repository'
require_relative '../app/infrastructure/repositories/postgres_repository'
require_relative '../app/infrastructure/repositories/repository_factory'
require_relative '../app/infrastructure/services/jwt_service'
require_relative '../app/infrastructure/middleware/authentication'
require_relative '../app/infrastructure/middleware/compression'
require_relative '../app/interfaces/web/controllers/products_controller'
require_relative '../app/interfaces/web/controllers/users_controller'
require_relative '../app/interfaces/web/controllers/openapi_controller'
require_relative '../app/interfaces/web/controllers/authors_controller'
require_relative '../app/infrastructure/services/logger_service'

# Configure RSpec
RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods

  # Load factories
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end

# Helper method to get the app
def app
  @app ||= Rack::Builder.parse_file('config.ru').first
end 