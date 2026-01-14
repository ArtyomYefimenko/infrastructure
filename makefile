COMPOSE_CMD := $(shell (command -v "docker" >/dev/null 2>&1 && docker compose version >/dev/null 2>&1 && echo "docker compose") || echo "docker-compose")

PRODUCT_SERVICE_REPO=https://github.com/ArtyomYefimenko/product-service.git
ORDER_SERVICE_REPO=https://github.com/ArtyomYefimenko/order-service.git
PAYMENT_SERVICE_REPO=https://github.com/ArtyomYefimenko/payment-service.git
AUTH_SERVICE_REPO=https://github.com/ArtyomYefimenko/auth-service.git
GATEWAY_SERVICE_REPO=https://github.com/ArtyomYefimenko/gateway-service.git

SERVICES := product-service order-service payment-service auth-service gateway-service

.PHONY: fetch-services build run logs clean

fetch-services:
	@echo "Fetching all microservices..."
	@for service in $(SERVICES); do \
		if [ ! -d "../$$service" ]; then \
			echo "Cloning $$service..."; \
			git clone $${service^^}_REPO ../$$service; \
		else \
			echo "$$service already exists, skipping..."; \
		fi \
	done

build: init-volumes
	$(COMPOSE_CMD) -f docker-compose.yml build

init-volumes:
	@for v in product_pgdata order_pgdata payment_pgdata auth_pgdata; do \
		docker volume create $$v || true; \
	done

run:
	$(COMPOSE_CMD) -f docker-compose.yml up -d

logs:
	$(COMPOSE_CMD) -f docker-compose.yml logs -f --tail=100

clean:
	$(COMPOSE_CMD) -f docker-compose.yml down -v
