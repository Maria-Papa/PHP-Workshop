# Define source and docker-compose paths
SRC_DIR=src
COMPOSE_FILE=docker/docker-compose.yml

# Export user info for permission consistency inside containers
export UID := $(shell id -u)
export GID := $(shell id -g)

# --- Setup Commands ---

# Initialize Laravel project
init:
	mkdir -p $(SRC_DIR)
	if [ ! -f $(SRC_DIR)/artisan ]; then \
		docker run --rm \
			-v $(PWD)/$(SRC_DIR):/app \
			-w /app \
			composer create-project laravel/laravel . --no-scripts; \
		sudo chown -R $$(id -u):$$(id -g) $(SRC_DIR); \
		cp .env.docker $(SRC_DIR)/.env; \
		echo "Laravel installed in $(SRC_DIR)"; \
	else \
		echo "Laravel already exists in $(SRC_DIR)"; \
	fi

# Build Docker images
build:
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) build

# Start containers
up:
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) up -d

# Stop containers
down:
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) down

# Rebuild and restart
restart: down build up

# Full setup (Laravel + Docker, no keygen)
start: init build up

# --- Laravel Utility Commands ---

# Generate application key and refresh config
keygen:
	@set -e; \
	if [ ! -f $(SRC_DIR)/.env ]; then \
		echo "$(SRC_DIR)/.env not found. Creating it from .env.docker..."; \
		cp .env.docker $(SRC_DIR)/.env; \
	fi; \
	sudo chown -R $$(id -u):$$(id -g) $(SRC_DIR); \
	echo "Generating new APP_KEY..."; \
	NEW_KEY=$$(UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) exec -T app php artisan key:generate --show) || { \
		echo "Failed to generate APP_KEY"; exit 1; \
	}; \
	sed -i.bak "s|^APP_KEY=.*|APP_KEY=$$NEW_KEY|" $(SRC_DIR)/.env || { \
		echo "Failed to update APP_KEY in $(SRC_DIR)/.env"; exit 1; \
	}; \
	cp $(SRC_DIR)/.env .env.docker || { \
		echo "Failed to sync .env to .env.docker"; exit 1; \
	}; \
	echo "Re-caching Laravel config..."; \
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) exec -T app php artisan config:clear; \
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) exec -T app php artisan config:cache; \
	echo "Reloading PHP-FPM..."; \
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) exec -T app sh -c "kill -USR2 1 || pkill -o -USR2 php-fpm || killall -USR2 php-fpm || true"; \
	echo "APP_KEY updated, config reloaded"

# Run Laravel artisan commands
# Usage: make artisan ARGS="migrate"
artisan:
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) exec -T app php artisan $(ARGS)

# Run tests
# Usage: make test ARGS="--filter=test_example"
test:
	-UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) exec -T app php artisan test $(ARGS)

# Run composer commands
# Usage: make composer ARGS="require laravel/sanctum"
composer:
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) exec -T app composer $(ARGS)

# Open shell in the app container
bash:
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) exec app bash

# Migrate with force (prod safe)
migrate:
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) exec -T app php artisan migrate --force

# View Laravel logs
logs:
	docker-compose -f $(COMPOSE_FILE) logs -f app

# --- Clean-up Commands ---

# Remove Laravel, containers, volumes, and images
clean:
	@read -p "Are you sure you want to delete everything? (y/N): " ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		echo "Deleting src/ directory..."; \
		sudo rm -rf src/; \
		echo "Stopping containers..."; \
		UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) down; \
		echo "Removing containers..."; \
		docker ps -aq --filter "name=laravel-" | xargs -r docker rm -f; \
		echo "Removing volumes..."; \
		UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) down --volumes; \
		echo "Removing default images..."; \
		for image in nginx:alpine redis:8.0.1-alpine mongo:7.0-jammy postgres:15-alpine; do \
			docker rmi -f "$$image" || true; \
		done; \
		echo "Clean-up complete."; \
	else \
		echo "Aborted."; \
	fi
