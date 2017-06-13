# Papernet Suite - Docker

This section explains how to compile the Papernet Suite with docker or docker-compose.

It allows to:
- Run a development docker container for Papernet contributors
- Wrap distribution version of its components into small sized and secured docker containers (scratch or alpine+gosu)

## Quick 

### with Docker Compose (recommended)
```bash
make docker.compose.all
```

### with Docker
```bash
make docker.build.all
```

## with Docker Compose

## with Docker

## List docker-containers:
```bash
docker images --filter "label=papernet.component.group=backend"
```
