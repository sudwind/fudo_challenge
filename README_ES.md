## fudo_challenge

Una aplicación escrtina en Ruby que implementa un sistema de gestión de productos

## Descripción General

Esta aplicación proporciona una API RESTful para gestionar productos, con características que incluyen:
- Autenticación de usuarios
- Creación y recuperación de productos
- Búsqueda de productos
- Listado de productos

## Prerrequisitos

- Ruby 3.2.0 o superior
- PostgreSQL 12 o superior (opcional, para almacenamiento persistente)
- Docker (opcional, para despliegue en contenedores)

### Ejecutar la aplicación

Con `ruby` instalado, simplemente ejecute:

```bash
bundle install
```

Luego, para iniciar la aplicación:
```bash
rackup
```

Esto ejecutará la aplicación en modo predeterminado con almacenamiento en memoria.

### Configuración del Entorno

La aplicación puede configurarse usando un archivo `.env`. Consulte `.env.example` para ver las opciones disponibles.

Opciones de configuración principales:
- `USE_DATABASE`: Establecer como `postgres` para usar PostgreSQL en lugar del almacenamiento en memoria
- `JWT_SECRET`: Clave secreta para la generación de tokens JWT
- `POSTGRES_*`: Configuración de la base de datos (ver más abajo)

### Configuración de PostgreSQL

Para usar PostgreSQL como alternativa de almacenamiento persistente a la base de datos en memoria, configure `USE_DATABASE=postgres` y configure lo siguiente:

```
POSTGRES_DB=nombre_de_su_base_de_datos
POSTGRES_USER=su_usuario
POSTGRES_PASSWORD=su_contraseña
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
```

Puede establecer estas variables en `.env` o como variables de entorno antes de ejecutar `rackup`:

```bash
USE_DATABASE=postgres rackup
```

### Despliegue con Docker

Construir la imagen:
```bash
docker build -t ruby-example-app .
```

Ejecutar el contenedor:
```bash
docker run -p 9292:9292 ruby-example-app
```

## Documentación de la API

### Autenticación

#### Creación de usuario
```
POST /users/login
Content-Type: application/json

{
  "email": "admin@example.com",
  "password": "admin123"
}
```

#### Inicio de sesión
```
POST /users/login
Content-Type: application/json

{
  "email": "admin@example.com",
  "password": "admin123"
}
```

Respuesta:
```json
{
  "token": "token jwt aqui"
}
```

### Productos

#### Obtener Producto por ID
```
GET /products/{product_id}
Authorization: Bearer {token}
```

#### Buscar Productos
```
GET /products/search?q={query}
Authorization: Bearer {token}
```

#### Listar Todos los Productos
```
GET /products
Authorization: Bearer {token}
```

## Pruebas

Ejecutar la suite de pruebas:
```bash
bundle exec rspec
```

## Arquitectura

### Capas
- **Dominio**: Lógica de negocio central y entidades
- **Aplicación**: Casos de uso y reglas de negocio
- **Infraestructura**: Interfaces externas (base de datos, web)
- **Interfaces**: Controladores web y endpoints de API

### Componentes Principales
- **Casos de Uso**: Implementan la lógica de negocio
- **Repositorios**: Manejan la persistencia de datos
- **Controladores**: Manejan las peticiones HTTP
- **Servicios**: Coordinan entre capas


Esta aplicación fue escrita siguiendo los principios de la arquitectura hexagonal, adaptada un poco a Ruby donde tenía sentido.

Debido a que Ruby utiliza duck typing, no hay necesidad real de especificar interfaces que otras clases terminen implementando, aunque implementé dos interfaces de base de datos para demostrar que puede funcionar perfectamente en Ruby de todos modos.

Fue bastante divertido hacer esto, y después de un tiempo, Ruby se siente bastante elegante y agradable de usar. 