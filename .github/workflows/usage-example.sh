#!/bin/bash

# Enable bash expand aliases for non-interactive shells
shopt -s expand_aliases

# Wrapper
alias wrap='
{
 for c in $(cat); do
  alias ${TOOL_NAME:-${c}}="${CONTAINER_RUN:-podman run -i --rm} docker.io/kran0/tiny:${c}";
 done;
 unset c;
}<<<'

wrap 'svn xmlstarlet curl jq'

function addElementToMatrix {
 [ -z "${MATRIX}" ] && MATRIX='{}'
 jq --compact-output --arg tag "${1:-trunk}" --arg revision "${2:-HEAD}" ' . += {
 "include":[
  { "tag": $tag, "revision": $revision }
 ]
}' <<< "${MATRIX:-'{}'}"
}

# Begin MATRIX construction

# Add trunk to the matrix
[ "${BUILD_TRUNK:-true}" '==' 'true' ] && MATRIX=$(addElementToMatrix)

# Search the release pattern in the latest 100 svn repo commits
# Print revision and version number
# Set LATEST_REVISION and LATEST_VERSION env vars
LATEST=$(svn log https://svn.code.sf.net/p/davmail/code/trunk --limit 100 --search 'Prepare [0-9]*.[0-9]*.[0-9]* release' --xml\
  | xmlstarlet sel -T -t -m '/log/logentry[1]' -v 'concat(@revision, " " , substring-before(substring-after(msg, "Prepare "), " release"))' -n)
LATEST_REVISION="${LATEST%% *}"
LATEST_VERSION="${LATEST##* }"
unset LATEST

# Get docker TAGS
# Check previous built image with TAG=LATEST_VERSION
# Set BUILD_RELEASE on fail
curl --silent https://registry.hub.docker.com/v1/repositories/kran0/davmail-docker/tags\
 | jq -r '.[].name'\
 | grep -wq "${LATEST_VERSION}" || BUILD_RELEASE=true

# Add release to the MATRIX
[ "${BUILD_RELEASE:-false}" '==' 'true' ] && MATRIX=$(addElementToMatrix ${LATEST_REVISION} ${LATEST_VERSION})
# Todo: for some strange reason, if the element (.include) is the same, the command above replaces its content. Suitable for us!

echo "::set-output name=matrix::${MATRIX}"
