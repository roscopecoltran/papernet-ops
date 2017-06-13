#!/bin/sh
set -x
set -e

if [ "$ENTRYPOINT_MODE" == "" ];then
	CASE=${ENTRYPOINT_MODE}
else
	CASE=${1}
	ENTRYPOINT_ARGS=${@:2}
fi

export GOPATH=/tmp/go
export PATH=${PATH}:${GOPATH}/bin
export BUILDPATH=${GOPATH}/src/${PROJECT_VCS_PROVIDER}/${PROJECT_NAMESPACE}/${PROJECT_NAME}
export PKG_CONFIG_PATH="/usr/lib/pkgconfig/:/usr/local/lib/pkgconfig/"

export APP_CERTIFICATES="/app/configuration/certs"
export APP_SSL_SELFSIGNED_BASENAME="${PROJECT_NAME}_self-signed"

export APP_WEB="/dist/web/xc/linux/${PROJECT_NAME}-linux-amd64-web"
export APP_CLI="/dist/cli/xc/linux/${PROJECT_NAME}-linux-amd64-cli"

if [ -d "/tmp/go" ];then
	export GOPATH=/tmp/go
	export PATH=${PATH}:${GOPATH}/bin
	export PROJECT_SOURCE_PATH=${GOPATH}/src/${PROJECT_VCS_PROVIDER}/${PROJECT_NAMESPACE}/${PROJECT_NAME}
fi

generate_oauth_basic () {

	set +e
	MKJWK_EXECUTABLE=$(which mkjwk)
	set -e

	if [ "${MKJWK_EXECUTABLE}" != "" ]; then
		mkdir -p ${APP_CERTIFICATES}
		cd ${APP_CERTIFICATES}
		mkjwk
		ls -l rsa_key 
		ls -l rsa_key.jwk
		cp -f rsa_key /dist/web/conf/${PROJECT_NAME}_rsa-key
		cp -f rsa_key /dist/cli/conf/${PROJECT_NAME}_rsa-key
		cp -f rsa_key.jwk /dist/cli/conf/${PROJECT_NAME}_rsa-key.jwk
		cp -f rsa_key.jwk /dist/web/conf/${PROJECT_NAME}_rsa-key.jwk
	fi

}


generate_self_signed () {

	set +e
	OPENSSL_EXECUTABLE=$(which openssl)
	set -e

	if [ "${OPENSSL_EXECUTABLE}" != "" ]; then
		openssl req -out ${APP_CERTIFICATES}/${APP_SSL_SELFSIGNED_BASENAME}.csr -subj "${APP_PREBUILD_SSL_SELFSIGNED_SUBJ}" -new -newkey rsa:2048 -nodes -keyout ${APP_CERTIFICATES}/${APP_SSL_SELFSIGNED_BASENAME}.key
		openssl req -x509 -sha256 -nodes -days 365 -subj "${APP_PREBUILD_SSL_SELFSIGNED_SUBJ}" -newkey rsa:2048 -keyout ${APP_CERTIFICATES}/${APP_SSL_SELFSIGNED_BASENAME}.key -out ${APP_CERTIFICATES}/${APP_SSL_SELFSIGNED_BASENAME}.crt
		cp -Rf ${APP_SSL_SELFSIGNED_BASENAME}.* /dist/web/conf/
		cp -Rf ${APP_SSL_SELFSIGNED_BASENAME}.* /dist/cli/conf/
	fi

}

cross_buid () {

	if [ "${GOLANG_EXECUTABLE}" == "" ]; then
		APK_BUILD="curl git mercurial bzr gcc musl-dev go g++ make"
		apk update 
		apk --no-cache --no-progress --virtual BUILD_DEPS add ${APK_BUILD}
	fi

	if [ "${GOX_EXECUTABLE}" == "" ]; then
		go get -v github.com/mitchellh/gox
		GOX_EXECUTABLE=$(which gox)
	fi

	if [ "${GLIDE_EXECUTABLE}" == "" ]; then
		go get -v github.com/Masterminds/glide
	fi

	if [ "${GODEP_EXECUTABLE}" == "" ]; then
		go get -u -v github.com/golang/dep/...
	fi

	cd ${PROJECT_SOURCE_PATH}

	if [ -d "$BUILDPATH/.git" ];then
		APP_GIT_COMMIT=$(git rev-parse HEAD)
		APP_GIT_DIRTY=$(test -n "`git status --porcelain`" && echo "+CHANGES" || true)
		gox -os="linux darwin" -arch="amd64" -ldflags "-X main.GitCommit=${APP_GIT_COMMIT}${APP_GIT_DIRTY}" -output /dist/{{.Dir}}/xc/{{.OS}}/${PROJECT_NAME}-{{.OS}}-{{.Arch}}-{{.Dir}} $(glide novendor)
	else
		gox -os="linux darwin" -arch="amd64" -output /dist/{{.Dir}}/xc/{{.OS}}/${PROJECT_NAME}-{{.OS}}-{{.Arch}}-{{.Dir}} $(glide novendor)
	fi

	echo " - APP_CLI: ${APP_CLI}"
	echo " - APP_WEB: ${APP_WEB}"

	generate_oauth_basic
	generate_self_signed

	#if [ -f "${APP_CLI}" ];then
		mkdir -p /dist/cli
		rm -f /dist/cli/${PROJECT_NAME}_cli
		cp ${APP_CLI} /dist/cli/${PROJECT_NAME}_cli
	#fi

	#if [ -f "${APP_WEB}" ];then
		mkdir -p /dist/web
		rm -f /dist/web/${PROJECT_NAME}_web
		cp ${APP_WEB} /dist/web/${PROJECT_NAME}_web
	#fi

}

case "$CASE" in
	'xc')
		cross_buid
	;;

	'generate-key')
		if [ "${MKJWK_EXECUTABLE}" == "" ]; then
		  go get -v -u github.com/dqminh/organizer/mkjwk
		fi
	  mkjwk ${@:2}
	  ls -l rsa_key 
	  ls -l rsa_key.jwk
	  mkdir -p /app/configuration/certs
	  rm -f /app/configuration/certs/rsa_key*
	  cp -f rsa_key* /app/configuration/certs
	  ls -l /app/configuration/certs
	;;

	'cli')

		if [ "$ENTRYPOINT_MODE" == "rebuild" ];then	
			GOOS=linux GOARCH=amd64 go build -o /dist/cli/${PROJECT_NAME}-linux-amd64-cli cmd/cli/*.go
		fi

		if [ "$ENTRYPOINT_MODE" == "run" ];then	
		  exec go run cmd/cli/main.go ${@:2}
		else
		  exec /dist/cli/${PROJECT_NAME}-linux-amd64-cli ${@:2}
		fi	

	;;

	'web')

		if [ "$ENTRYPOINT_MODE" == "rebuild" ];then	
			GOOS=linux GOARCH=amd64 go build -o /dist/web/${PROJECT_NAME}-linux-amd64-web cmd/web/*.go
		fi

		if [ "$ENTRYPOINT_MODE" == "run" ];then	
		  exec go run cmd/web/main.go ${@:2}
		else
		  exec /dist/web/${PROJECT_NAME}-linux-amd64-web ${@:2}
		fi	

	;;

	'index')
		if [ "$ENTRYPOINT_MODE" == "rebuild" ];then
			GOOS=linux GOARCH=amd64 go build -o /dist/${PROJECT_NAME}-linux-amd64-cli cmd/cli/*.go
			exec /dist/${PROJECT_NAME}-linux-amd64-cli index create --index=${APP_DATA_DIR:-"/data"}/${PROJECT_NAME}.index --mapping=${APP_INDEX_MAPPING_FILE:-"./bleve/mapping.json"}
		else			
			#exec go run cmd/cli/*.go index create ${@:2}
			exec go run cmd/cli/*.go index create --index=${APP_DATA_DIR:-"/data"}/${PROJECT_NAME}.index --mapping=${APP_INDEX_MAPPING_FILE:-"./bleve/mapping.json"}
		fi
	;;

	'bash')
		if [ "${BASH_EXECUTABLE}" == "" ]; then
			apk --update --no-progress --no-cache add bash # --no-progress 
		fi
		exec /bin/bash ${@:2}

	;;

	'bashpp')
		if [ "${BASH_EXECUTABLE}" == "" ]; then
			apk --update --no-progress --no-cache add bash nano tree # --no-progress 
		fi
		exec /bin/bash ${@:2}

	;;

	'sh')
		exec sh ${@:2}
	;;

	'test')
		exec go test $(go list ./... | grep -v /vendor/)

	;;

  *)

	touch /dist/web/${PROJECT_NAME}_web
	touch /dist/cli/${PROJECT_NAME}_cli

	generate_oauth_basic
	generate_self_signed

	echo " *** Dev Container '${APP_NAME} Back-End' *** exit now..."
	;;
esac
