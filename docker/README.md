# Docker-Compose

This section explains how to compile Papernet front-end and back-end with docker-compose.

It allows to:
- Run a development docker container for Papernet contributors
- Wrap distribution version of its components into small sized and secured docker containers (scratch or alpine+gosu)

## Papernet back-end

# Examples:
```bash
- make papernet.docker.compose.backend.all 
- make papernet.docker.compose.backend.all DOCKER_BUILD_NOCACHE=true
```

# check containers size:
```bash
docker images
```

```bash
papernet-backend    alpine-go1.8-dev    460d3c817835        17 hours ago        772 MB
papernet-web        scratch-latest      b566bfc99ac1        2 hours ago         22.6 MB
papernet-cli        scratch-latest      1c70e353bf2e        2 hours ago         20.7 MB
```




## Build dev environment
```bash
make papernet.docker.compose.dev.all DOCKER_BUILD_NOCACHE=true
smake papernet.docker.compose.dev.backend DOCKER_BUILD_NOCACHE=true
make papernet.docker.compose.dev.frontend DOCKER_BUILD_NOCACHE=true
```

## Builld all front-end
```bash
make papernet.docker.compose.dist.all
```

## Builld all back-end
```bash
make papernet.docker.compose.dist.all
```

## Wrap front-end and back-end dist output
```bash
make papernet.docker.compose.dist.all
make papernet.docker.compose.dist.backend
make papernet.docker.compose.dist.frontend
```

