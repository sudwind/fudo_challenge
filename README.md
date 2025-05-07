## fudo_challenge

A Ruby application implementing a product management system

## Overview

This application provides a RESTful API for managing products, with features including:
- User authentication
- Product creation and retrieval
- Product search
- Product listing

## Prerequisites

- Ruby 3.2.0 or higher
- PostgreSQL 12 or higher (optional, for persistent storage)
- Docker (optional, for containerized deployment)

### Running the application

With `ruby` installed, you can simply do:

```bash
bundle install
```

Then, to start the application:
```bash
rackup
```

This will run the app in default mode with in-memory storage.

### Environment Configuration

The application can be configured using an `.env` file. See `.env.example` for available options.

Key configuration options:
- `USE_DATABASE`: Set to `postgres` to use PostgreSQL instead of in-memory storage
- `JWT_SECRET`: Secret key for JWT token generation
- `POSTGRES_*`: Database configuration (see below)

### PostgreSQL Configuration

To use PostgreSQL as a persistent storage alternative to the in-memory database, set `USE_DATABASE=postgres` and configure the following:

```
POSTGRES_DB=your_db_name
POSTGRES_USER=your_db_user
POSTGRES_PASSWORD=your_db_password
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
```

You can set these either in `.env` or as environment variables before running `rackup`:

```bash
USE_DATABASE=postgres rackup
```

### Docker Deployment

Build the image:
```bash
docker build -t ruby-example-app .
```

Run the container:
```bash
docker run -p 9292:9292 ruby-example-app
```

## API Documentation

### Authentication

#### User creation
```
POST /users/login
Content-Type: application/json

{
  "email": "admin@example.com",
  "password": "admin123"
}
```

#### Login
```
POST /users/login
Content-Type: application/json

{
  "email": "admin@example.com",
  "password": "admin123"
}
```

Response:
```json
{
  "token": "jwt_token_here"
}
```

### Products

#### Get Product by ID
```
GET /products/{product_id}
Authorization: Bearer {token}
```

#### Search Products
```
GET /products/search?q={query}
Authorization: Bearer {token}
```

#### List All Products
```
GET /products
Authorization: Bearer {token}
```

## Testing

Run the test suite:
```bash
bundle exec rspec
```

## Architecture

### Layers
- **Domain**: Core business logic and entities
- **Application**: Use cases and business rules
- **Infrastructure**: External interfaces (database, web)
- **Interfaces**: Web controllers and API endpoints

### Key Components
- **Use Cases**: Implement business logic
- **Repositories**: Handle data persistence
- **Controllers**: Handle HTTP requests
- **Services**: Coordinate between layers


This app was written by following hexagonal architecture principles, adapted a bit to Ruby where it made sense.

Due to Ruby using duck typing, there is no actual need to specify interfaces that other clases end up implementing, I did end up implementing two database interfaces to demostrate that it can work flawlessly under Ruby nevertheless.

It was kind of fun doing this, and after a while, Ruby does feel kind of elegant and nice to use.