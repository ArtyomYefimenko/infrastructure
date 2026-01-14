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
			case "$$service" in \
				product-service) url=$(PRODUCT_SERVICE_REPO) ;; \
				order-service) url=$(ORDER_SERVICE_REPO) ;; \
				payment-service) url=$(PAYMENT_SERVICE_REPO) ;; \
				auth-service) url=$(AUTH_SERVICE_REPO) ;; \
				gateway-service) url=$(GATEWAY_SERVICE_REPO) ;; \
			esac; \
			echo "Cloning $$service..."; \
			git clone $$url ../$$service; \
		else \
			echo "$$service already exists, skipping..."; \
		fi \
	done

build: init-volumes init-env
	$(COMPOSE_CMD) -f docker-compose.yml build

init-volumes:
	@for v in product_pgdata order_pgdata payment_pgdata auth_pgdata; do \
		docker volume create $$v || true; \
	done

init-env:
	@for service in $(SERVICES); do \
		if [ ! -f ../$$service/.env ]; then \
			if [ -f ../$$service/.env.example ]; then \
				echo "Copying .env.example to .env for $$service..."; \
				cp ../$$service/.env.example ../$$service/.env; \
			else \
				echo "Creating empty .env for $$service..."; \
				touch ../$$service/.env; \
			fi \
		else \
			echo ".env already exists for $$service, skipping..."; \
		fi \
	done

run:
	$(COMPOSE_CMD) -f docker-compose.yml up -d

stop:
	$(COMPOSE_CMD) -f docker-compose.yml down

logs:
	$(COMPOSE_CMD) -f docker-compose.yml logs -f --tail=100

clean:
	$(COMPOSE_CMD) -f docker-compose.yml down -v
