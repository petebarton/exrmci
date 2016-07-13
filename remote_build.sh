#!/bin/bash
# remote_build.sh
# Executes the build.sh on the remote server.

# Make sure they passed us the arguments, $1=app_name, $2=version(from git describe).
${2:?"%%%%%%%%%%%%% Error: You must pass the app name and version as parameters to this script  %%%%%%%%%%%"}

set -e

ssh -p 23 -o StrictHostKeyChecking=no $BUILD_USER_AND_IP "bash -s" -- < /exrmci/build.sh $1 $2


