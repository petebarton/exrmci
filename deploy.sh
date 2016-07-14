#!/bin/bash
# deploy.sh
##########################################################################################
# This script deploys an elixir release locally.
#
# PREREQUISITS
#   - You should have already extracted one release to the DEPLOY_ROOT_DIR.
#   - The box that we are deploying to should have an ssh key to the build box.
#
#
# The following environment variables should be set in /exrmi/exrmci_env_vars
# 
# APP_NAME          # my_app
# BUILD_RELEASE_DIR # root@10.0.0.3:/my_app-releases     # NO TRAILING SLASH(/) !!!
# DEPLOY_ROOT_DIR   # /home/joe/deploy_my_app            # NO TRAILING SLASH(/) !!!
#
##########################################################################################

set -e


# Make sure we have the required arg.
: ${1?"%%%%%%%%%%%%% Error: version (git describe) must be passed as first arg. %%%%%%%%%%%"}

# Run the env_vars file.
source /exrmci/exrmci_env_vars

echo "APP_NAME: $APP_NAME"
echo "BUILD_RELEASE_DIR: $BUILD_RELEASE_DIR"
echo "DEPLOY_ROOT_DIR: $DEPLOY_ROOT_DIR"

# Make sure we have the required env vars.
: ${APP_NAME?"         %%%%%%%%%%%%% Error: ENV VAR 'APP_NAME' NOT FOUND  %%%%%%%%%%%"}
: ${BUILD_RELEASE_DIR?"%%%%%%%%%%%%% Error: ENV VAR 'REPO_PATH' NOT FOUND  %%%%%%%%%%%"}
: ${DEPLOY_ROOT_DIR?"  %%%%%%%%%%%%% Error: ENV VAR 'DEPLOY_ROOT' NOT FOUND  %%%%%%%%%%%"}



echo ""
echo ""

echo "Start: get the release"
  mkdir -p $DEPLOY_ROOT_DIR/$1
  scp -r $BUILD_RELEASE_DIR/$1/$APP_NAME.tar.gz $DEPLOY_ROOT_DIR/releases/$1/
echo "Done:  get the release"

echo ""

echo "Start: UPGRADE the release"
  cd $DEPLOY_ROOT_DIR && ./bin/$APP_NAME upgrade  $1
echo "Done:  UPGRADE the release"


echo ""
echo ""

exit 0




######### EXAMPLE CODE ##########################################
# /apps/pxblog-exrm/bin/pxblog upgrade 0.0.2
# /apps/pxblog-exrm/bin/pxblog downgrade 0.0.1
#    mix release
#    mkdir -p /tmp/test/releases/0.0.2
#    cp rel/test/releases/0.0.2/test.tar.gz /tmp/test/releases/0.0.2/
#    cd /tmp/test
#    bin/test upgrade "0.0.2"
#################################################################






