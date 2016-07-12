#!/bin/bash
# deploy
##########################################################################################
# This script deploys an elixir release on a remote (or local) server.
# It uses ssh to run commands on the remote server.
#
# PREREQUISITS
#   - there should be a /releases directory
#   - The box that we are deploying to should have an ssh key to the build box.
#
#
# The following environment variables should be set before running this script.
# 
# APP_ROOT =              /code/my_elixir_app
# BUILD_USER_AND_IP =     root@10.0.0.2
# DEPLOY_USER_AND_IP =    root@10.0.0.3
# $GO_REVISION_APP_GIT =  root@10.0.0.3
#
##########################################################################################

set -e

echo ""
echo ""

echo "Start: get the release"
  ssh -p 23 -o StrictHostKeyChecking=no $DEPLOY_USER_AND_IP "scp -r $BUILD_USER_AND_IP:/releases/$GO_REVISION_APP_GIT /releases/"
echo "Done:  get the release"

echo ""

echo "Start: run the release"
  ssh -p 23 -o StrictHostKeyChecking=no $DEPLOY_USER_AND_IP "cd /releases && rel/$APP_NAME/bin/$APP_NAME start"
echo "Done:  run the release"

# /apps/pxblog-exrm/bin/pxblog upgrade 0.0.2
# /apps/pxblog-exrm/bin/pxblog downgrade 0.0.1

echo ""
echo ""

exit 0









