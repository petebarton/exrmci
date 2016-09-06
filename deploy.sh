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
echo "DEPLOY_RELEASE_DIR: $DEPLOY_RELEASE_DIR"
echo "DEPLOY_ROOT_DIR: $DEPLOY_ROOT_DIR"

# Make sure we have the required env vars.
: ${APP_NAME?"         %%%%%%%%%%%%% Error: ENV VAR 'APP_NAME' NOT FOUND  %%%%%%%%%%%"}
: ${BUILD_RELEASE_DIR?"%%%%%%%%%%%%% Error: ENV VAR 'BUILD_RELEASE_DIR' NOT FOUND  %%%%%%%%%%%"}
: ${DEPLOY_RELEASE_DIR?"%%%%%%%%%%%%% Error: ENV VAR 'DEPLOY_RELEASE_DIR' NOT FOUND  %%%%%%%%%%%"}
: ${DEPLOY_ROOT_DIR?"  %%%%%%%%%%%%% Error: ENV VAR 'DEPLOY_ROOT' NOT FOUND  %%%%%%%%%%%"}



echo ""

echo "Start: GET the release"
  mkdir -p $DEPLOY_RELEASE_DIR
  scp $BUILD_RELEASE_DIR/$APP_NAME_$1.tar.gz $DEPLOY_RELEASE_DIR/
echo "Done:  GET the release"

echo ""

echo "Start: UNZIP the release"
  cd $DEPLOY_ROOT_DIR
  ./bin/$APP_NAME stop || true
  rm -rf *
  cp $DEPLOY_RELEASE_DIR/$APP_NAME_$1.tar.gz .
  tar -zxvf $APP_NAME_$1.tar.gz
echo "Done:  UNZIP the release"

echo ""

echo "Start: START the release"
  RELX_REPLACE_OS_VARS=true ./bin/$APP_NAME start
echo "Done:  START the release"


echo ""
echo ""

exit 0





