#!/bin/bash
# build.sh
##########################################################################################
# This script builds an elixir release on a local server.
#
# PREREQUISITS
#   - The app repo should be git cloned to the build server prior to running this script.
#   - The git repo should have at least one tag and respond to 'git describe --long'.
#   - The mix.exs file should use System.cmd("git", ["describe", "--long"]) to populate the project version.
#   - The "rel" directory should be .gitignored.
#   - If a Test db is needed, then it should be created and migrated already.
#
#
# Environment variables are stored in the file '/exrmci/exrm_vars' (An example file is included in this repo.)
# 
##########################################################################################



set -e

# Make sure they passed us the arguments, $1=app_name, $2=version(from git describe).
: ${2?"%%%%%%%%%%%%% Error: You must pass the app name and version as parameters to this script  %%%%%%%%%%%"}





echo ""
echo ""

echo "******* Start:  Git pull"
  cd /$APP_NAME && sudo git checkout master && sudo git checkout . && sudo git pull
echo "******* Done:  Git pull."

echo ""

echo "******* Start: Git checkout correct version..."
  git checkout master && git checkout $1
echo "******* Done:  Git checkout correct version..."

echo ""

echo "******* Start: install rebar"
  mix local.rebar --force
echo "******* Done:  install rebar"

echo ""

echo "******* Start: mix clean"
  mix clean
echo "******* Done:  mix clean"

echo ""

echo "******* Start: get the deps"
  mix deps.get
echo "******* Done:  get the deps"

echo ""

echo "******* Start: mix test"
  mix test
echo "******* Done:  mix test"

echo ""

echo "******* Start: compile"
  MIX_ENV=prod mix compile
echo "******* Done:  compile"

echo ""

echo "******* Start: digest the assets"
  MIX_ENV=prod mix phoenix.digest
echo "******* Done:  digest the assets"

echo ""

echo "******* Start: Build the release"
  MIX_ENV=prod mix release
echo "******* Done:  Build the release"

echo ""
echo ""

exit 0









