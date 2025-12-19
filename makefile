COMPOSE_CMD := $(shell (command -v "docker" >/dev/null 2>&1 && docker compose version >/dev/null 2>&1 && echo "docker compose") || echo "docker-compose")


build:
	docker volume create product_pgdata || true
	docker volume create order_pgdata || true
	$(COMPOSE_CMD) -f docker-compose.yml build

run:
	$(COMPOSE_CMD) -f docker-compose.yml up