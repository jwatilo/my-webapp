#!/bin/bash

cd $(dirname $(which $0))/..

declare S2I="s2i build"

if [ -n "${HTTP_PROXY}" ] ; then
  S2I="${S2I} --env \"HTTP_PROXY=\${HTTP_PROXY}\""
fi

if [ -n "${HTTPS_PROXY}" ] ; then
  S2I="${S2I} --env \"HTTPS_PROXY=\${HTTPS_PROXY}\""
elif [ -n "${HTTP_PROXY}" ] ; then
  S2I="${S2I} --env \"HTTPS_PROXY=\${HTTP_PROXY}\""
fi

S2I="${S2I} --env \"DEV_MODE=true\""
S2I="${S2I} --loglevel 1"
S2I="${S2I} ./ rhscl/nodejs-8-rhel7 $(basename ${PWD})"
echo ${S2I}
eval ${S2I}
