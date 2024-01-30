#!/bin/bash

# Source the .env file
if [ -f ./env/docker_login.env ]; then
    export $(cat ./env/docker_login.env | sed 's/#.*//g' | xargs)
    echo "$IASON_REGISTRY_PASSWORD" | docker login "$IASON_REGISTRY" --username "$IASON_REGISTRY_USER" --password-stdin
else
    echo ".env file not found"
    exit 1
fi

# Docker login
