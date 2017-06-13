# Papernet FRONT-END - Docker

This section explains how to compile Papernet 'front-end' with 'docker' cli or 'docker-compose'.

It allows to:
- Run a development docker container for Papernet front-end components
- Wrap front-end static version into a small sized and secured docker containers (scratch or alpine 3.6 with gosu)

## Quick 
```bash
make compose.all
```

## with Docker Compose (recommended)

### Builld 'DEV' container for Papernet 'FRONT-END'
```bash
make papernet.docker.compose.dev.frontend 
make papernet.docker.compose.dev.frontend DOCKER_BUILD_NOCACHE=false
```

### Builld all 'DISTRIBUTION' containers for Papernet 'FRONT-END'
```bash
make papernet.docker.compose.dist.frontend
```

### Other build commands:
```bash
- make papernet.docker.compose.frontend.all 
- make papernet.docker.compose.frontend.all DOCKER_BUILD_NOCACHE=true
```

## with Docker

## List docker-containers:
```bash
docker images --filter "label=papernet.component.group=frontend"
```

