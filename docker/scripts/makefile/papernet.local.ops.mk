
## #################################################################
## TITLE
## #################################################################

## OPS
APP_OPS_VCS_URI   		:= "github.com/bobinette/papernet-ops"
APP_OPS_VCS_BRANCH		:= "master"
APP_OPS_PATH_REL     	:= "$(PROJECTS_DIRNAME)/$(APP_OPS_VCS_URI)"
APP_OPS_PATH      		:= "$(PROJECTS_PATH)/$(APP_OPS_VCS_URI)"

papernet.ops.add: projects.dir.check
	@ if [ ! -d "$(APP_OPS_PATH)" ]; then \
		git subtree add --prefix $(APP_OPS_PATH_REL) https://$(APP_OPS_VCS_URI) $(APP_OPS_VCS_BRANCH) --squash ; \
	  else \
		echo "Skipping request as remote repository was already added $(APP_OPS_VCS_URI)"; \
	  fi

papernet.ops.pull: projects.dir.check
	@ if [ ! -d "$(APP_OPS_PATH)" ]; then \
		git subtree add --prefix $(APP_OPS_PATH_REL) https://$(APP_OPS_VCS_URI) $(APP_OPS_VCS_BRANCH) --squash ; \
	  else \
		git subtree pull --prefix $(APP_OPS_PATH_REL) https://$(APP_OPS_VCS_URI) $(APP_OPS_VCS_BRANCH) --squash ; \
	  fi

papernet.ops.push:
	@git subtree push --prefix $(APP_OPS_PATH_REL) https://$(APP_OPS_VCS_URI) $(APP_OPS_VCS_BRANCH)

papernet.ops.remove:
	@rm -fR $(APP_OPS_PATH)

papernet.subtree.ops: papernet.ops.pull