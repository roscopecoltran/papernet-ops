#!/bin/sh
set -x
set -e

# Set temp environment vars
export GOPATH=/tmp/go
export PATH=${PATH}:${GOPATH}/bin
export BUILDPATH=${GOPATH}/src/${PROJECT_VCS_PROVIDER}/${PROJECT_NAMESPACE}/${PROJECT_NAME}
export PKG_CONFIG_PATH="/usr/lib/pkgconfig/:/usr/local/lib/pkgconfig/"

if [ "$GOLANG_PKG_MANAGER" == "glide" ];then
  export GLIDE_HOME=${GOPATH}/glide/home
  export GLIDE_TMP=${GOPATH}/glide/tmp
  mkdir -p ${GLIDE_HOME}
  mkdir -p ${GLIDE_TMP}

elif [ "$GOLANG_PKG_MANAGER" == "godep" ];then
  export CCACHE_DIR="${GOPATH}/godep/cache"
  mkdir -p ${CCACHE_DIR}
fi

# Install build deps
apk --no-cache --no-progress --virtual INTERACTIVE add ${ALPINE_PKG_INTERACTIVE}
apk --no-cache --no-progress --virtual BUILD add ${ALPINE_PKG_BUILD}

# Get the parent directory of where this script is.
SOURCE="$0"

while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done

# Get the git commit
CURRENT_DIR=$(pwd)

# If its dev mode, only build for ourself
if [ "${TF_DEV}x" != "x" ]; then
    XC_OS=${XC_OS:-$(go env GOOS)}
    XC_ARCH=${XC_ARCH:-$(go env GOARCH)}
fi

# Determine the arch/os combos we're building for
XC_ARCH=${XC_ARCH:-"386 amd64 arm"}
XC_OS=${XC_OS:-linux darwin windows freebsd openbsd}
GOLANG_CROSS_BUILDER=${GOLANG_CROSS_BUILDER:-gox}

# Install dependencies
echo "==> Getting dependencies..."
if [ "$GOLANG_CROSS_BUILDER" == "gox" ];then
  go get -v github.com/mitchellh/gox
fi

if [ "$GOLANG_PKG_MANAGER" == "glide" ];then
  go get -v github.com/Masterminds/glide
else
  go get -u -v github.com/golang/dep/...
fi

# Init go environment to build papernet
mkdir -p $(dirname ${BUILDPATH})
ln -s /app ${BUILDPATH}
cd ${BUILDPATH}

if [ "$GOLANG_PKG_MANAGER" == "glide" ];then
  glide install --strip-vendor
  # nb. go test $(glide novendor)
else
  dep ensure
fi

# Delete the old dir
echo "==> Removing old directory..."

# Build!
echo "==> Building..."
set +e

if [ -d "$BUILDPATH/.git" ];then
  GIT_COMMIT=$(git rev-parse HEAD)
  GIT_DIRTY=$(test -n "`git status --porcelain`" && echo "+CHANGES" || true)
  XC_LDFLAGS="-ldflags \"-X main.GitCommit ${GIT_COMMIT}${GIT_DIRTY}\""
else
  XC_LDFLAGS=""
fi

if [ "$GOLANG_PKG_MANAGER" == "glide" ];then
  XC_SOURCE=$(glide novendor)
else
  XC_SOURCE="./cmd/..."
fi

mkdir -p /dist/xc

# bug with os and arch parameters when passed as docker build arguments
# gox -os="${XC_OS}" -arch="${XC_ARCH}" ${XC_LDFLAGS} -output \"/dist/{{.Dir}}/${PROJECT_NAME}_{{.Dir}}_{{.OS}}_{{.Arch}}\" ${XC_SOURCE}
if [ -d "$BUILDPATH/.git" ];then
  gox -os="linux darwin" -arch="amd64" -ldflags "-X main.GitCommit=${GIT_COMMIT}${GIT_DIRTY}" -output /dist/xc/{{.OS}}/{{.Dir}}/${PROJECT_NAME}-{{.OS}}-{{.Arch}}-{{.Dir}} $(glide novendor)
else
  gox -os="linux darwin" -arch="amd64" -output /dist/xc/{{.OS}}/{{.Dir}}/${PROJECT_NAME}-{{.OS}}-{{.Arch}}-{{.Dir}} $(glide novendor)
fi

tree /dist/xc/

# copy binaries for dist containers/wrappers
mkdir -p /dist/cli
mkdir -p /dist/web

cp -f /dist/xc/linux/cli/${PROJECT_NAME}-linux-amd64-cli /dist/cli/${PROJECT_NAME}_cli
cp -f /dist/xc/linux/web/${PROJECT_NAME}-linux-amd64-web /dist/web/${PROJECT_NAME}_web

if [ "$APP_PREBUILD_AUTH" == "mkjwk" ];then
  go get -v -u github.com/dqminh/organizer/mkjwk
  mkjwk
  ls -l rsa_key 
  ls -l rsa_key.jwk
  mkdir -p /app/configuration/certs
  cp -f rsa_key* /app/configuration/certs
fi

if [ "$APP_TASK_MANAGER" != "" ];then
  go get -v -u ${APP_TASK_MANAGER}
fi

# Done!
echo
echo "==> Results:"
tree /dist/

# cleanup
if [ "${APP_PREBUILD_DEL}" == "true" ];then

  # Cleanup GOPATH
  rm -r ${GOPATH}
  apk --no-cache del BUILD # --no-progress 

fi

