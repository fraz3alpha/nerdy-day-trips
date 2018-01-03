#!/usr/bin/env bash

# This script pushing the built copy of the this site to a staging repository

# Enable exit on failure
set -e

# based on https://jekyllrb.com/docs/continuous-integration/travis-ci/

SITE_DIR=_site

# Clear out the build directory
rm -rf ${SITE_DIR} && mkdir ${SITE_DIR}

# Build the site
bundle exec jekyll build

# Initialise the git repo
cd ${SITE_DIR}
git init
# Add the target remote
git remote add origin https://github.com/fraz3alpha/nerdy-day-trips-staging.git
# Create a new branch, and commit all the code
git checkout -b gh-pages
git add -A
git commit -m 'Travis build for staging'
git log -1
git push --force origin gh-pages
