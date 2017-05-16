#!/bin/bash

set -e

CMD="${1}"
if [ "$#" -lt 1 ]; then
  echo "Usage: <command>"
  exit 1
fi

WD=${PWD}
DEF_SRCPATH="x/y/z"
if [ -z "${SRCPATH}" ]; then
  SRCPATH=${DEF_SRCPATH}
fi

P="/go/src/${SRCPATH}"
mkdir -p ${P}

if [ "$(ls -A $WD)" ]; then
  cp -r * ${P}
fi

cd ${P}

export GOPATH="${P}/vendor:/go"

build() {
  if [ "${DEF_SRCPATH}" == "${SRCPATH}" ]; then
    APPNAME="app"
  else
    APPNAME=$(basename $SRCPATH)
  fi
  GITHASH=${3-unknown}
  TAGVERSION=${4-latest}
  CGO_ENABLED=0 go build -o $APPNAME -a -installsuffix cgo -ldflags "-s -X main.buildinfobuildtime=$(date '+%Y-%m-%d_%I:%M:%S%p') -X main.buildinfogithash=${GITHASH} -X main.buildinfoversion=${TAGVERSION-latest}"
  cp ${APPNAME} ${WD}
  chmod a+rwx ${WD}/${APPNAME}
}

builddetailed() {
  APPNAME=$1
  shift
  CGO_ENABLED=0 go build $@
  cp ${APPNAME} ${WD}
  chmod a+rwx ${WD}/${APPNAME}
}

case "${1}" in
  build)
    build ${WD} $@
    ;;
  test)
    go test
    ;;
  fmt)
    cd ${WD}
    go fmt
    ;;
  version)
    go version
    ;;
  *)
    echo "Invalid command."
    ;;
esac

exit 0
