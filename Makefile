#
#? Settings and Variables (Works for windows 11)
#? CURDIR is the directory of the Makefile, even if it is called from a subdirectory with make -C
#
DOCKER_COMPOSE_FILE := $(CURDIR)/docker/docker-compose.yaml
ENV_FILE := $(CURDIR)/env/docker.env
DOCKER_FLAGS := --file $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE)
DOCKER_COMPOSE := docker compose $(DOCKER_FLAGS)
NPX_PREFIX := npx --prefix $(CURDIR)/app
# include $(CURDIR)/env/docker.env

.PHONY: print
print:
	@echo "CURDIR" $(CURDIR)
	@echo "@D" $(@D)
	@echo "@F" $(@F)
	@echo "@" $(@)
	@echo "%" $(%)
	@echo "%D" $(%D)

.PHONY: .ONESHELL
.ONESHELL:

.PHONY: dev
dev:
	set LOCAL_DEV=true
	set NODE_ENV=development
	set CLIENT_IP=127.0.0.1
	set CLIENT_PORT=3000
	set DOCKER_CLIENT_PORT_FORWARD=3501
	set OUTER_PORT_FRONTEND=80
	set SERVER_IP=127.0.0.1
	set SERVER_PORT=80
	set INNER_PORT_FRONTEND=3000
	set DOCKER_SERVER_PORT_FORWARD=3500
	cd $(CURDIR)/app && $(NPX_PREFIX) pnpm dev

#
#? Docker
#
.PHONY: up
up:
	$(DOCKER_COMPOSE) up

.PHONY: build
build:
	$(DOCKER_COMPOSE) build

.PHONY: down
down:
	$(DOCKER_COMPOSE) down

.PHONY: clean
clean:
	$(DOCKER_COMPOSE) down --remove-orphans --volumes
