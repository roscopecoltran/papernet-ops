####################################################################################
# Makefile (configuration file for GNU make - see http://www.gnu.org/software/make/)
#     __  __       _         __ _ _
#    |  \/  | __ _| | _____ / _(_) | ___
#    | |\/| |/ _` | |/ / _ \ |_| | |/ _ \
#    | |  | | (_| |   <  __/  _| | |  __/
#    |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
#
#
####################################################################################
#
############################## Variables Declarations ##############################

.PHONY: all

## #################################################################
## Makefile - Papernet project 
## #################################################################

## project vcs info 
APP_NAME        		:= "papernet"
APP_NAMESPACE   		:= "bobinette"
APP_VCS_PROVIDER		:= "github.com"
APP_VCS_URI     		:= "$(APP_VCS_PROVIDERAPP_NAMESPACE)/$(APP_NAME)"

## project dirs & config files
APP_DATA_DIR          	:= "$(CURDIR)/data/$(APP_NAME)"

# network settings
APP_API_HOST  			:= 0.0.0.0
APP_API_PORT  			:= 1705
APP_FRONT_HOST			:= 0.0.0.0
APP_FRONT_PORT			:= 8080

# compile info
TEST?=./...
BIND_DIR 				:= "dist"
BIND_PATH				:= "$(CURDIR)/$(BIND_DIR)"
DIST_PATH				:= "$(CURDIR)/$(BIND_DIR)"

# helpers dirs
SCRIPTS_PATH			:= $(CURDIR)/scripts

PROJECTS_DIRNAME		:= projects
PROJECTS_PATH			:= $(CURDIR)/$(PROJECTS_DIRNAME)

# certs, auth files dirs
CONFIG_CERTS_PATH		:= $(CURDIR)/conf/certs

## #################################################################
## Makefile modules
## #################################################################

## build/deploy helpers
include $(CURDIR)/scripts/makefile/common/env.mk
include $(CURDIR)/scripts/makefile/common/pre-requisites.mk
include $(CURDIR)/scripts/makefile/common/help.mk
include $(CURDIR)/scripts/makefile/security/certs.mk
include $(CURDIR)/scripts/makefile/vcs/git.mk
include $(CURDIR)/scripts/makefile/languages/golang.mk
include $(CURDIR)/scripts/makefile/compile/golang_xc.mk	

## sub-projects experimental addons helpers
include $(CURDIR)/scripts/makefile/experimental/*.mk

## sub-projects (official) addons helpers
include $(CURDIR)/scripts/makefile/papernet*.mk

## #################################################################
## Project docker info
## #################################################################

## docker registry
DOCKER_IMAGE_TAG 				:= "latest"
DOCKER_USERNAME  				:= "$(APP_NAMESPACE)"
DOCKER_IMAGE_NAME				:= "$(APP_NAME)"

## dockerfile - default filename
DOCKERFILE_DEV               	:= "Dockerfile.build.alpine"

## docker cache system
DOCKER_BUILD_NOCACHE			:= true
DOCKER_BUILD_CACHE_ARG			:= $(if $(filter $(DOCKER_BUILD_NOCACHE),true), --no-cache)

# Docker-Compose: build FRONT and BACK components for dev and production mode
docker.compose.all: docker.is.cache docker.config.dispatch.all papernet.docker.compose.all
docker.compose.backend: docker.is.cache docker.config.dispatch.all papernet.docker.compose.backend.all
docker.compose.frontend: docker.is.cache docker.config.dispatch.all papernet.docker.compose.frontend.all

# Configuration files
docker.config.dispatch.all: docker.is.first.time docker.config.dispatch.backend
docker.config.dispatch.backend:
	@echo " copy/dispatch configuration files for 'back-end' containers"

## notes:
##  - Dispatch demo/dev configuration files to dist folders before, either the developers will manage those configuration files

# Quick checks
docker.is.first.time:
	@echo "check if the demo/dev configuration files have already been dispatched to dist folders..."

docker.is.cache:
	@echo "is docker using cache system?"
	@echo " - DOCKER_BUILD_NOCACHE=$(DOCKER_BUILD_NOCACHE)"
	@echo " - DOCKER_BUILD_CACHE_ARG=$(DOCKER_BUILD_CACHE_ARG)"


