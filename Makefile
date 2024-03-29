#
#? Settings and Variables (Works for windows 11)
#? CURDIR is the directory of the Makefile, even if it is called from a subdirectory with make -C
#

# Makefile

# Load .env file if it exists
ifneq (,$(wildcard ./env/pipeline.env))
    include ./env/pipeline.env
    export
endif


AWS_BUCKET := thanos-test
DOCKER_COMPOSE_FILE := $(CURDIR)/docker/docker-compose.yaml
ENV_FOLDER := $(CURDIR)/env
ENV_FILE := $(ENV_FOLDER)/docker.env
THANOS_ENV_FILE := $(ENV_FOLDER)/thanos.env
DOCKER_LOGIN_ENV_FILE := $(ENV_FOLDER)/docker_login.env
DOCKER_FLAG_FILE := --file $(DOCKER_COMPOSE_FILE)
DOCKER_FLAGS_ENV := --env-file $(ENV_FILE)\
					--env-file $(DOCKER_LOGIN_ENV_FILE)\
					--env-file $(THANOS_ENV_FILE)

DOCKER_COMPOSE_RAW := docker compose $(DOCKER_FLAG_FILE)
DOCKER_COMPOSE := $(DOCKER_COMPOSE_RAW) $(DOCKER_FLAGS_ENV)
NPX_PREFIX := npx --prefix $(CURDIR)/app

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

.PHONY: fresh
fresh:
	$(DOCKER_COMPOSE_RAW) down --remove-orphans --volumes
	$(DOCKER_COMPOSE) build --no-cache

.PHONY: clean
clean:
	$(DOCKER_COMPOSE_RAW) down --remove-orphans --volumes

.PHONY: d-login
d-login:
	echo "$(LOCAL_REGISTRY_PASSWORD)" | docker login $(LOCAL_REGISTRY) --username $(LOCAL_REGISTRY_USER) --password-stdin
	echo "login completed"
.PHONY: reset
reset:
	curl -X POST http://localhost:9090/-/reload

.PHONY: aws_b
aws_b:
	aws s3 ls s3://$(AWS_BUCKET)/ --profile szin --recursive --human-readable --summarize

