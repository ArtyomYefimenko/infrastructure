# Infrastructure

This module contains Docker Compose configuration for running all Microshop services together in a single environment.

## Responsibilities

- Runs all microservices as a unified system
- Provides a shared Docker network for inter-service communication
- Manages infrastructure components (databases, gateway, services)

---

## Requirements

- Git
- Docker >= 24
- Docker Compose >= 2.15
- GNU Make


## Setup

1. **Create repository for microshop projects locally:**
```bash
mkdir microshop && cd microshop
```

2. **Clone the infrastructure repository:**
```bash
git clone https://github.com/ArtyomYefimenko/infrastructure.git
cd infrastructure
```

3. **Clone all microservices (can be automated via Makefile):**
```bash
make fetch-services
```
This will clone the following repositories next to the infrastructure folder:
- [product-service](https://github.com/ArtyomYefimenko/product-service)
- [order-service](https://github.com/ArtyomYefimenko/order-service)
- [payment-service](https://github.com/ArtyomYefimenko/payment-service)
- [auth-service](https://github.com/ArtyomYefimenko/auth-service)
- [gateway-service](https://github.com/ArtyomYefimenko/gateway-service)

4. **Build all Docker images:**
```bash
make build
```

5. **Run the entire system:**
```bash
make run
```

The Gateway Service will be available at:
👉 http://localhost:8000/docs

6. **Stop all services:**
```bash
make stop 
```

## Services Included

- Gateway Service
- Product Service
- Order Service
- Payment Service
- Auth Service
- PostgreSQL databases for each service
- Kafka for `order` and `payment` services

## Networking

- All containers are connected to a shared Docker bridge network
- Internal services communicate using service names as hosts
- Only the Gateway Service is exposed to the host machine

---

## Notes

- By default, services run in development mode (--reload enabled)
- For production or staging, healthchecks are enabled, and logs may include /health requests