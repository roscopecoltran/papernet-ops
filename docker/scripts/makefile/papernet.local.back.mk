
## #################################################################
## TITLE
## #################################################################

## BACK-END
APP_BACKEND_VCS_URI   	:= "github.com/bobinette/papernet"
APP_BACKEND_VCS_BRANCH	:= "master"
APP_BACKEND_PATH_REL   	:= "$(PROJECTS_DIRNAME)/$(APP_BACKEND_VCS_URI)"
APP_BACKEND_PATH      	:= "$(PROJECTS_PATH)/$(APP_BACKEND_VCS_URI)"

#### Papernet WEB-UI
papernet.backend.add: projects.dir.check
	@ if [ ! -d "$(APP_BACKEND_PATH)" ]; then \
		git subtree add --prefix $(APP_BACKEND_PATH_REL) https://$(APP_BACKEND_VCS_URI) $(APP_BACKEND_VCS_BRANCH) --squash ; \
	  else \
		echo "Skipping request as remote repository was already added $(APP_BACKEND_VCS_URI)"; \
	  fi

papernet.backend.pull: projects.dir.check
	@ if [ ! -d "$(APP_BACKEND_PATH)" ]; then \
		git subtree add --prefix $(APP_BACKEND_PATH_REL) https://$(APP_BACKEND_VCS_URI) $(APP_BACKEND_VCS_BRANCH) --squash ; \
	  else \
		git subtree pull --prefix $(APP_BACKEND_PATH_REL) https://$(APP_BACKEND_VCS_URI) $(APP_BACKEND_VCS_BRANCH) --squash ; \
	  fi

papernet.backend.push:
	@git subtree push --prefix $(APP_BACKEND_PATH_REL) https://$(APP_BACKEND_VCS_URI) $(APP_BACKEND_VCS_BRANCH)

papernet.backend.clean:
	@rm -fR $(DIST_PATH)/front/content/*
	@rm -fR $(APP_BACKEND_PATH)/app/content/*

papernet.backend.remove:
	@rm -fR $(APP_BACKEND_PATH)

papernet.subtree.backend: papernet.backend.pull