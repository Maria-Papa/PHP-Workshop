# Define source directory
SRC_DIR=src

# Define docker-compose file path
COMPOSE_FILE=docker/docker-compose.yml

# Export current user UID and GID for docker-compose usage
export UID := $(shell id -u)
export GID := $(shell id -g)

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
		echo "✅ Laravel installed in $(SRC_DIR)"; \
	else \
		echo "✅ Laravel already exists in $(SRC_DIR)"; \
	fi

# Build Docker images, passing UID/GID environment variables
build:
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) build

# Start containers, passing UID/GID environment variables
up:
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) up -d

# Stop containers
down:
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) down

# Generate app key manually
keygen:
	@set -e; \
	if [ ! -f $(SRC_DIR)/.env ]; then \
		echo "⚠️  $(SRC_DIR)/.env not found. Creating it from .env.docker..."; \
		cp .env.docker $(SRC_DIR)/.env; \
	fi; \
	sudo chown -R $$(id -u):$$(id -g) $(SRC_DIR); \
	echo "🔑 Generating new APP_KEY..."; \
	NEW_KEY=$$(UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) exec -T app php artisan key:generate --show) || { \
		echo "❌ Failed to generate APP_KEY"; exit 1; \
	}; \
	sed -i.bak "s|^APP_KEY=.*|APP_KEY=$$NEW_KEY|" $(SRC_DIR)/.env || { \
		echo "❌ Failed to update APP_KEY in $(SRC_DIR)/.env"; exit 1; \
	}; \
	cp $(SRC_DIR)/.env .env.docker || { \
		echo "❌ Failed to sync .env to .env.docker"; exit 1; \
	}; \
	echo "✅ APP_KEY updated"

# Run migrations manually
migrate:
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) exec app php artisan migrate --force

# Run artisan commands
artisan:
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) exec app php artisan $(filter-out $@,$(MAKECMDGOALS)) $(ARGS)

# Run tests
test:
	UID=$(UID) GID=$(GID) docker-compose -f $(COMPOSE_FILE) exec app php artisan test

# Tail logs
logs:
	docker-compose -f $(COMPOSE_FILE) logs -f app

# Remove Laravel & Clean Docker
clean:
	@read -p "Are you sure you want to delete src/ and bring down and clean containers (y/N)? " ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		echo "Deleting src/ directory..."; \
		sudo rm -rf src/; \
		echo "Stopping containers..."; \
		UID=$(UID) GID=$(GID) docker-compose -f docker/docker-compose.yml down; \
		echo "Force removing containers..."; \
		docker ps -aq --filter "name=laravel-" | xargs -r docker rm -f; \
		echo "Removing volumes..."; \
		UID=$(UID) GID=$(GID) docker-compose -f docker/docker-compose.yml down --volumes; \
		echo "Removing images..."; \
		for image in nginx:alpine redis:8.0.1-alpine mongo:7.0-jammy postgres:15-alpine; do \
			docker rmi -f "$$image" || true; \
		done; \
		echo "Cleanup complete."; \
	else \
		echo "Aborted."; \
	fi

# Fix permissions locally (useful before build or running containers)
fix-permissions:
	sudo chown -R $(UID):$(GID) src/.env src/storage src/bootstrap/cache
	sudo chmod -R 775 src/storage src/bootstrap/cache
	sudo chmod 644 src/.env

# Rebuild and restart
restart: down build up

# From scratch to up (no keygen/migrate)
start: init build up
