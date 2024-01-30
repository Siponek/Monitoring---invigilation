#!/bin/bash

files=("docker.env" "docker_login.env" "pipeline.env" "grafana.env")
echo "Checking for required files"
for file in "${files[@]}"; do
    if [ -f "./env/$file" ]; then
        echo "$file found"
    else
        echo "$file not found"
        exit 1
    fi
done
# Source the .env file
if [ -f ./env/docker_login.env ]; then
    export $(cat ./env/docker_login.env | sed 's/#.*//g' | xargs)
    echo "$IASON_REGISTRY_PASSWORD" | docker login "$IASON_REGISTRY" --username "$IASON_REGISTRY_USER" --password-stdin
else
    echo "docker_login.env file not found"
    exit 1
fi

# Docker login
