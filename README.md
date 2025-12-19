# Infrastructure

This module contains Docker Compose configuration for running all Microshop services together in a single environment.

## Responsibilities

- Runs all microservices as a unified system
- Provides a shared Docker network for inter-service communication
- Manages infrastructure components (databases, gateway, services)

## Services Included

- Gateway Service
- Product Service
- Order Service
- Payment Service
- Auth Service
- PostgreSQL databases for each service

All services are started within the same Docker network, allowing them to communicate using service names as hosts.

## Networking

- All containers are connected to a shared Docker bridge network
- Internal services are **not exposed publicly**
- Only the Gateway Service exposes ports to the host machine

## Running the Infrastructure

```bash
docker-compose up
