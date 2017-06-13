# Papernet BACK-END - Docker

This section explains how to compile Papernet 'back-end' with 'docker' cli or 'docker-compose'.

It allows to:
- Run a development docker container for Papernet back-end components
- Wrap distribution version of its components into small sized and secured docker containers (scratch or alpine+gosu)

## Quick 
```bash
make compose.all
```

## with Docker Compose

### Builld 'DEV' container for Papernet 'BACK-END'
```bash
make papernet.docker.compose.dev.backend 
make papernet.docker.compose.dev.backend DOCKER_BUILD_NOCACHE=false
```

### Builld all 'DISTRIBUTION' containers for Papernet 'BACK-END'
```bash
make papernet.docker.compose.dist.backend
```

### Other build commands:
```bash
- make papernet.docker.compose.backend.all 
- make papernet.docker.compose.backend.all DOCKER_BUILD_NOCACHE=true
```

## with Docker

## List docker-containers:
```bash
docker images --filter "label=papernet.component.group=backend"
```
