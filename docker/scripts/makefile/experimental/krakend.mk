
## #################################################################
## TITLE
## urls:
##  - https://github.com/devopsfaith/krakend
##  - https://github.com/devopsfaith/krakend-docker
## #################################################################

## Addon - KRAKEND
APP_ADDON_KRAKEND_DIR       		:= "krakend"
APP_ADDON_KRAKEND_PATH      		:= "$(APP_ADDONS_DIR)/$(APP_ADDON_KRAKEND_DIR)"
APP_ADDON_KRAKEND_VCS_URI   		:= "https://github.com/devopsfaith/krakend.git"
APP_ADDON_KRAKEND_VCS_BRANCH		:= "master"

krakend-add:
	@ if [ ! -d "$(APP_ADDON_KRAKEND_PATH)" ]; then \
		git subtree add --prefix $(APP_ADDON_KRAKEND_DIR) $(APP_ADDON_KRAKEND_VCS_URI) $(APP_ADDON_KRAKEND_VCS_BRANCH) --squash ; \
	  else \
		echo "Skipping request as remote repository was already added $(APP_ADDON_KRAKEND_VCS_URI)"; \
	  fi

krakend-update:
	@git subtree pull --prefix $(APP_ADDON_KRAKEND_DIR) $(APP_ADDON_KRAKEND_VCS_URI) $(APP_ADDON_KRAKEND_VCS_BRANCH) --squash

krakend-push:
	@git subtree push --prefix $(APP_ADDON_KRAKEND_DIR) $(APP_ADDON_KRAKEND_VCS_URI) $(APP_ADDON_KRAKEND_VCS_BRANCH)