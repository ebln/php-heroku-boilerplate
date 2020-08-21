.DEFAULT_GOAL := help

.PHONY: help up start run down stop enter logs

help: ## Show this help.
	@grep -E '^[a-zA-Z_-]+:.*?##\s*.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##\\s*"}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

up:##Create and start containers
	docker-compose up --detach
start:##Alias of «up»
	$(MAKE) up
run:##Alias of «up»
	$(MAKE) up

down:##Create and start containers
	docker-compose down --remove-orphans
stop:##Alias of «down»
	$(MAKE) down

enter:##Obtain shell access to the main container
	docker-compose exec web /bin/bash

logs:##Tail container logs
	docker-compose logs --follow
