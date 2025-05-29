# Makefile

# Define source directory
SRC_DIR=src

# Initialize Laravel project
init:
	mkdir -p $(SRC_DIR)
	if [ ! -f $(SRC_DIR)/artisan ]; then \
		docker run --rm \
			-v $(PWD)/$(SRC_DIR):/app \
			-w /app \
			composer create-project laravel/laravel .; \
		sudo chown -R $$(id -u):$$(id -g) $(SRC_DIR); \
		echo "✅ Laravel installed in $(SRC_DIR)"; \
	else \
		echo "✅ Laravel already exists in $(SRC_DIR)"; \
	fi

# Build Docker images
build:
	docker-compose build

# Start containers
up:
	docker-compose up -d

# Stop containers
down:
	docker-compose down

# Run migrations
migrate:
	docker-compose exec app php artisan migrate

# Run artisan
artisan:
	docker-compose exec app php artisan $(filter-out $@,$(MAKECMDGOALS))

# Run tests
test:
	docker-compose exec app php artisan test

# Tail logs
logs:
	docker-compose logs -f app

# Rebuild and restart
restart: down build up

# One command to go from scratch to ready
start: init build up migrate
