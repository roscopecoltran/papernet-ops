
## #################################################################
## TITLE
## #################################################################

# to finish

papernet.docker.run.back:
	@echo "Running docker container for $(APP_NAME)"
	@docker run -t -i -v ${APP_DATA_DIR}:/data -p 0.0.0.0:$(APP_PORT_API):$(APP_PORT_API) $(or $(TAG), $(DOCKER_USERNAME)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG))
	@echo "Done."

papernet.docker.remove.back:
	@echo "Removing existing docker image"
	@docker rmi $(or $(TAG), $(DOCKER_USERNAME)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG))
	@echo "Done."

papernet.docker.rebuild.back: papernet.docker.remove.back

papernet.docker.publish.back: 
	@echo "Publishing image to artifactory..."
	@docker push $(or $(TAG), $(DOCKER_USERNAME)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG))
	@echo "Done."

# APP_MOUNT    			:= -v "$(CURDIR)/$(BIND_DIR):/go/src/$(APP_VCS_URI)/$(BIND_DIR)"
# APP_DEV_IMAGE			:= $(APP_NAME)-dev$(if $(GIT_BRANCH),:$(subst /,-,$(GIT_BRANCH)))
# APP_IMAGE    			:= $(if $(REPONAME),$(REPONAME),"$(DOCKER_USERNAME)/$(DOCKER_IMAGE_NAME)")

# DOCKER_RUN_OPTS     	:= $(PAPERNET_ENVS) $(PAPERNET_MOUNT) "$(PAPERNET_DEV_IMAGE)"
# DOCKER_RUN_APP      	:= docker run $(INTEGRATION_OPTS) -it $(DOCKER_RUN_OPTS)
# DOCKER_RUN_APP_NOTTY	:= docker run $(INTEGRATION_OPTS) -i $(DOCKER_RUN_OPTS)
