## #################################################################
## TITLE
## #################################################################

## BACK-END
APP_EF_BACKEND_VCS_URI   	:= "github.com/feedlabs/elasticfeed"
APP_EF_BACKEND_VCS_BRANCH	:= "master"
APP_EF_BACKEND_PATH_REL   	:= "$(PROJECTS_DIRNAME)/$(APP_EF_BACKEND_VCS_URI)"
APP_EF_BACKEND_PATH      	:= "$(PROJECTS_PATH)/$(APP_EF_BACKEND_VCS_URI)"

#### Elastic-Feed WEB-API
elasticfeed.backend.add: projects.dir.check
	@ if [ ! -d "$(APP_EF_BACKEND_PATH)" ]; then \
		git subtree add --prefix $(APP_EF_BACKEND_PATH_REL) https://$(APP_EF_BACKEND_VCS_URI) $(APP_EF_BACKEND_VCS_BRANCH) --squash ; \
	  else \
		echo "Skipping request as remote repository was already added $(APP_BACKEND_VCS_URI)"; \
	  fi

# make elasticfeed.backend.pull
elasticfeed.backend.pull: projects.dir.check
	@ if [ ! -d "$(APP_EF_BACKEND_PATH)" ]; then \
		git subtree add --prefix $(APP_EF_BACKEND_PATH_REL) https://$(APP_EF_BACKEND_VCS_URI) $(APP_EF_BACKEND_VCS_BRANCH) --squash ; \
	  else \
		git subtree pull --prefix $(APP_EF_BACKEND_PATH_REL) https://$(APP_EF_BACKEND_VCS_URI) $(APP_EF_BACKEND_VCS_BRANCH) --squash ; \
	  fi

elasticfeed.backend.push:
	@git subtree push --prefix $(APP_EF_BACKEND_PATH_REL) https://$(APP_EF_BACKEND_VCS_URI) $(APP_EF_BACKEND_VCS_BRANCH)

elasticfeed.backend.clean:
	@rm -fR $(DIST_PATH)/front/content/*
	@rm -fR $(APP_EF_BACKEND_PATH)/app/content/*

elasticfeed.backend.remove:
	@rm -fR $(APP_EF_BACKEND_PATH)

elasticfeed.subtree.backend: elasticfeed.backend.pull