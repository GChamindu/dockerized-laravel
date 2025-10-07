SHELL = /bin/sh

UID := $(shell id -u)
GID := $(shell id -g)

export UID
export GID

up:
	docker compose up -d --remove-orphans

down:
	docker compose down --remove-orphans

build:
	@if [ ! -f ./.env ]; then cp ./.env.example ./.env; fi
	@UID=${UID} GID=${GID} docker compose up --build -d --remove-orphans
	@docker exec laravel_app /bin/sh -c "\
		composer install --no-interaction --prefer-dist --optimize-autoloader && \
		chmod -R 777 storage/ bootstrap/cache/ && \
		php artisan key:generate && \
		php artisan config:clear && \
		php artisan cache:clear && \
		php artisan route:clear && \
		php artisan view:clear && \
		php artisan migrate --force"

shell:
	docker exec -it laravel_app bash

logs:
	docker compose logs -f

network:
	docker network create laravel || true
