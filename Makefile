.PHONY: help build up down restart logs logs-app logs-db ps rebuild clean sh db-shell

.DEFAULT_GOAL := help

## Shows all the commands
help:
	@awk '/^## /{c=substr($$0,4)} /^[a-zA-Z0-9_-]+:/{split($$0,a,":"); if(c){printf "\033[36m%-15s\033[0m %s\n",a[1],c; c=""}}' $(MAKEFILE_LIST)

## Build the images
build:
	docker compose build

## Lift the containers in the background
up:
	docker compose up -d

## Stop and delete the containers (retain the volumes/data)
down:
	docker compose down

## Rebuilds the application image and restarts it (use after editing code)
rebuild:
	docker compose build app
	docker compose up -d

## Restart containers without rebuilding images
restart:
	docker compose restart

## Check the status of the containers
ps:
	docker compose ps

## Logs of all live services
logs:
	docker compose logs -f

## App-only logs
logs-app:
	docker compose logs -f app

## Logs only from the database
logs-db:
	docker compose logs -f db

## Open a shell inside the app container
sh:
	docker compose exec app sh

## Open the MariaDB client inside the database container
db-shell:
	docker compose exec db mariadb -u$${DB_USERNAME} -p$${DB_PASSWORD} $${MARIADB_DATABASE}
