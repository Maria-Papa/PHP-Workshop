# Makefile

# Define source directory
SRC_DIR=src

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
	UID=$(UID) GID=$(GID) docker-compose build

# Start containers, passing UID/GID environment variables
up:
	UID=$(UID) GID=$(GID) docker-compose up -d

# Stop containers
down:
	UID=$(UID) GID=$(GID) docker-compose down

# Generate app key manually
keygen:
	@set -e; \
	if [ ! -f $(SRC_DIR)/.env ]; then \
		echo "⚠️  $(SRC_DIR)/.env not found. Creating it from .env.docker..."; \
		cp .env.docker $(SRC_DIR)/.env; \
	fi; \
	sudo chown -R $$(id -u):$$(id -g) $(SRC_DIR); \
	echo "🔑 Generating new APP_KEY..."; \
	NEW_KEY=$$(UID=$(UID) GID=$(GID) docker-compose exec -T app php artisan key:generate --show) || { \
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
	UID=$(UID) GID=$(GID) docker-compose exec app php artisan migrate --force

# Run artisan commands
artisan:
	UID=$(UID) GID=$(GID) docker-compose exec app php artisan $(filter-out $@,$(MAKECMDGOALS)) $(ARGS)

# Run tests
test:
	UID=$(UID) GID=$(GID) docker-compose exec app php artisan test

# Tail logs
logs:
	docker-compose logs -f app

# Remove Laravel & Clean Docker
clean:
	@read -p "Are you sure you want to delete src/ and bring down and clean containers (y/N)? " ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		sudo rm -rf src/; \
		UID=$(UID) GID=$(GID) docker-compose down --volumes --rmi all; \
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
