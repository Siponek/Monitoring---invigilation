FROM node:21.5.0-bullseye-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    nano \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*
