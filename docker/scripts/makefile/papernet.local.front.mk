
## #################################################################
## TITLE
## #################################################################

## WEB-UI
APP_FRONTEND_VCS_URI   	:= "github.com/bobinette/papernet-front"
APP_FRONTEND_VCS_BRANCH	:= "master"
APP_FRONTEND_PATH_REL   := "$(PROJECTS_DIRNAME)/$(APP_FRONTEND_VCS_URI)"
APP_FRONTEND_PATH      	:= "$(PROJECTS_PATH)/$(APP_FRONTEND_VCS_URI)"

#### Papernet WEB-UI
papernet.frontend.add: projects.dir.check
	@ if [ ! -d "$(APP_FRONTEND_PATH)" ]; then \
		git subtree add --prefix $(APP_FRONTEND_PATH_REL) https://$(APP_FRONTEND_VCS_URI) $(APP_FRONTEND_VCS_BRANCH) --squash ; \
	  else \
		echo "Skipping request as remote repository was already added $(APP_FRONTEND_VCS_URI)"; \
	  fi

papernet.frontend.pull: projects.dir.check
	@ if [ ! -d "$(APP_FRONTEND_PATH)" ]; then \
		git subtree add --prefix $(APP_FRONTEND_PATH_REL) https://$(APP_FRONTEND_VCS_URI) $(APP_FRONTEND_VCS_BRANCH) --squash ; \
	  else \
		git subtree pull --prefix $(APP_FRONTEND_PATH_REL) https://$(APP_FRONTEND_VCS_URI) $(APP_FRONTEND_VCS_BRANCH) --squash ; \
	  fi

papernet.frontend.push:
	@git subtree push --prefix $(APP_FRONTEND_PATH_REL) https://$(APP_FRONTEND_VCS_URI) $(APP_FRONTEND_VCS_BRANCH)

papernet.frontend.clean:
	@rm -fR $(DIST_PATH)/front/content/*
	@rm -fR $(APP_FRONTEND_PATH)/app/content/*

papernet.frontend.remove:
	@rm -fR $(APP_FRONTEND_PATH)

papernet.subtree.frontend: papernet.frontend.pull