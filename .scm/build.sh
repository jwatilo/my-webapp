#!/bin/bash

cd $(dirname $(which $0))/..

declare DEV_MODE=false
declare LOG_LEVEL=1
declare S2I="s2i build"
declare PASSTHRU=
declare IMAGENAME=$(basename ${PWD})
declare IMAGETAG=latest # TODO: decide on a versioning scheme 
declare IMAGEREF=${IMAGENAME}:${IMAGETAG}

while [ -n "${1}" ] ; do
  case "${1}" in
    "--dev"      | "-dev"      ) DEV_MODE=true ;;
    "--loglevel" | "-loglevel" ) shift ; LOG_LEVEL=${1} ;;
    *                          ) PASSTHRU="${PASSTHRU} ${1}"
  esac
  shift
done

# remove docker image if it exists
if [ -n "$(docker images -q ${IMAGEREF} 2> /dev/null)" ] ; then
  docker rmi ${IMAGEREF}
fi

if [ -n "${HTTP_PROXY}" ] ; then
  S2I="${S2I} --env \"HTTP_PROXY=\${HTTP_PROXY}\""
fi

if [ -n "${HTTPS_PROXY}" ] ; then
  S2I="${S2I} --env \"HTTPS_PROXY=\${HTTPS_PROXY}\""
elif [ -n "${HTTP_PROXY}" ] ; then
  S2I="${S2I} --env \"HTTPS_PROXY=\${HTTP_PROXY}\""
fi

S2I="${S2I} --env \"DEV_MODE=true\""
S2I="${S2I} --loglevel ${LOG_LEVEL}"
S2I="${S2I} ./ rhscl/nodejs-8-rhel7 ${IMAGEREF}"
S2I="${S2I}${PASSTHRU}"
echo ${S2I}
eval ${S2I}
