#!/bin/sh
set -x
set +e

GIT_EXECUTABLE=$(which git)
BASH_EXECUTABLE=$(which bash)
OPENSSL_EXECUTABLE=$(which openssl)
NODEJS_EXECUTABLE=$(which node)
NPM_EXECUTABLE=$(which npm)
NCU_EXECUTABLE=$(which ncu)

set -e

build_static () {
	${NPM_EXECUTABLE} run build
	rm -Rf /dist/content/*
	cp -Rf /code/app/* /dist/content
}

case "$1" in

	'npm')
		exec ${NPM_EXECUTABLE} ${@:2}
	;;

	'run')
		exec ${NPM_EXECUTABLE} run ${@:2}
	;;

	'build')
		build_static
	;;

	'dev')
		exec ${NPM_EXECUTABLE} run dev
	;;

	'devv')
		exec ${NPM_EXECUTABLE} run dev:v
	;;

	'jest')
		exec ${NPM_EXECUTABLE} run jest
	;;

	'jestu')
		exec ${NPM_EXECUTABLE} run jest:u
	;;

	'lint')
		exec ${NPM_EXECUTABLE} run lint
	;;

	'lintf')
		exec ${NPM_EXECUTABLE} run lint:f
	;;

	'ping') 
		exec ${NODEJS_EXECUTABLE} -e "console.log('pong')"
	;;

	'ncu') 
		exec ${NCU_EXECUTABLE} > /code/app/packages.ncu.json
	;;

	'sh')
		exec sh ${@:2}
	;;

	'bash')
		if [ "${BASH_EXECUTABLE}" == "" ]; then
			apk --update --no-progress --no-cache add bash 
			BASH_EXECUTABLE=$(which bash)
		fi
		exec ${BASH_EXECUTABLE} ${@:2}
	;;

	'bashpp')
		if [ "${BASH_EXECUTABLE}" == "" ]; then
			apk --update --no-progress --no-cache add bash nano tree 
		fi
		exec ${BASH_EXECUTABLE} ${@:2}
	;;

	'test')
		exec npm run test
	;;

	*)
		build_static
		echo " *** Dev Container '${APP_NAME} Front-End' *** exit now..."
	;;

esac

# exit $?
