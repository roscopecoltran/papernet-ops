
## #################################################################
## TITLE
## #################################################################

# Examples:
# - make papernet.docker.compose.all DOCKER_BUILD_NOCACHE=false
# - make papernet.docker.compose.dev.all DOCKER_BUILD_NOCACHE=false
# - make papernet.docker.compose.dist.all
# - make papernet.docker.compose.check.all

# docker-compose build --no-cache frontend_dev && docker-compose run frontend_dev

## #################################################################
## COMMON
## #################################################################
# papernet.docker.compose.dev.all: papernet.docker.compose.dist.generated.cleanup papernet.docker.compose.dev.backend.build papernet.docker.compose.dev.frontend.build
papernet.docker.compose.dev.all: docker.is.cache papernet.docker.compose.dev.backend.build papernet.docker.compose.dev.frontend.build

# papernet.docker.compose.dist.all: papernet.docker.compose.dist.generated.cleanup papernet.docker.compose.dist.backend.build papernet.docker.compose.dist.frontend.build
papernet.docker.compose.dist.all: docker.is.cache papernet.docker.compose.dist.backend.wrap papernet.docker.compose.dist.backend.build papernet.docker.compose.dist.frontend.build

papernet.docker.compose.all: docker.is.cache papernet.docker.compose.dev.all papernet.docker.compose.dist.all

## #################################################################
## BACK-END
## #################################################################

# Containers size:
# - papernet-backend    alpine-go1.8-dev    460d3c817835        17 hours ago        772 MB
# - papernet-web        scratch-latest      b566bfc99ac1        2 hours ago         22.6 MB
# - papernet-cli        scratch-latest      1c70e353bf2e        2 hours ago         20.7 MB

# make papernet.docker.compose.all DOCKER_BUILD_NOCACHE=true

# Examples:
# - make papernet.docker.compose.backend.dev.all 
# - make papernet.docker.compose.backend.dev.all DOCKER_BUILD_NOCACHE=true
papernet.docker.compose.backend.dev.all: papernet.docker.compose.dev.backend.build papernet.docker.compose.dev.backend.run papernet.docker.compose.dist.backend.cli.wrap papernet.docker.compose.dist.backend.web.wrap

papernet.docker.compose.dist.backend.cli.wrap:
	@docker-compose -f docker-compose.prod.yml build $(DOCKER_BUILD_CACHE_ARG) cli

papernet.docker.compose.dist.backend.web.wrap:
	@docker-compose -f docker-compose.prod.yml build $(DOCKER_BUILD_CACHE_ARG) web

# $(APP_NAME).docker.compose.dev.backend.build: ---> for the bot and automated generation of compose files.
papernet.docker.compose.dev.backend.build:
	@echo "Running docker 'development' container for $(APP_NAME), component 'back-end'"
	@docker-compose -f docker-compose.yml build $(DOCKER_BUILD_CACHE_ARG) backend_dev

papernet.docker.compose.dist.backend.cli.run:
	@docker-compose -f docker-compose.prod.yml run cli

papernet.docker.compose.dist.backend.web.run:
	@docker-compose -f docker-compose.prod.yml run web

papernet.docker.compose.dev.backend.run:
	@echo "Running docker 'development' container for $(APP_NAME), component 'back-end'"
	@docker-compose -f docker-compose.yml run backend_dev

## #################################################################
## FRONT-END
## #################################################################

# Examples:
# - make papernet.docker.compose.frontend.all 
# - make papernet.docker.compose.frontend.all DOCKER_BUILD_NOCACHE=true

# Containers size:
# - papernet-front      caddy-latest        f07fdd9f91c9        4 minutes ago       43.5 MB
# - papernet-front      alpine-nodejs-dev   0b5b28a59f98        10 minutes ago      341 MB

papernet.docker.compose.frontend.all: papernet.docker.compose.dev.frontend.build papernet.docker.compose.dev.frontend.run papernet.docker.compose.dist.frontend.build

papernet.docker.compose.dist.frontend.build:
	@docker-compose -f docker-compose.prod.yml build $(DOCKER_BUILD_CACHE_ARG) front

papernet.docker.compose.dev.frontend.build:
	@echo "Running docker 'development' container for $(APP_NAME), component 'front-end'"
	@docker-compose -f docker-compose.yml build $(DOCKER_BUILD_CACHE_ARG) frontend_dev

papernet.docker.compose.dev.frontend.run:
	@echo "Running docker 'development' container for $(APP_NAME), component 'front-end'"
	@docker-compose -f docker-compose.yml run frontend_dev

## #################################################################
## CHECK
## #################################################################
papernet.docker.compose.dist.generated.check:
	@echo "to do"

## #################################################################
## CLEAN
## #################################################################
papernet.docker.compose.dist.generated.cleanup:
	@rm -fR $(CURDIR)/conf/certs/$(APP_NAME)_self*
	@rm -fR $(CURDIR)/conf/certs/$(APP_NAME)_rsa*

papernet.docker.compose.dist.generated.cleanup.cli:
	@rm -fR $(DIST_PATH)/cli/conf/$(APP_NAME)_self*
	@rm -fR $(DIST_PATH)/cli/conf/$(APP_NAME)_rsa*
	@rm -fR $(DIST_PATH)/cli/$(APP_NAME)_cli
	@rm -fR $(DIST_PATH)/cli/$(APP_NAME)-cli-*
	@rm -fR $(DIST_PATH)/cli/xc/*

papernet.docker.compose.dist.generated.cleanup.web:
	@rm -fR $(DIST_PATH)/web/conf/$(APP_NAME)_self*
	@rm -fR $(DIST_PATH)/web/conf/$(APP_NAME)_rsa*
	@rm -fR $(DIST_PATH)/web/$(APP_NAME)_web
	@rm -fR $(DIST_PATH)/web/$(APP_NAME)-web-*
	@rm -fR $(DIST_PATH)/web/xc/*

papernet.docker.compose.dist.generated.cleanup.front:
	@mv $(DIST_PATH)/front/content $(DIST_PATH)/front/content.old
	@mkdir -p $(DIST_PATH)/front/content
	@rm -fR $(DIST_PATH)/front/content.old

papernet.docker.compose.dist.generated.cleanup: papernet.docker.compose.dist.generated.cleanup.cli papernet.docker.compose.dist.generated.cleanup.web papernet.docker.compose.dist.generated.cleanup.front


