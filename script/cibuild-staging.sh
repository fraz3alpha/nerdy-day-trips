#!/usr/bin/env bash

# This script pushing the built copy of the this site to a staging repository

# Enable exit on failure
set -e

# based on https://jekyllrb.com/docs/continuous-integration/travis-ci/

SITE_DIR=_site

# Clear out the build directory
rm -rf ${SITE_DIR} && mkdir ${SITE_DIR}

# Fiddle around with some files so that it works for the staging environment
# Overwrite the CNAME file
echo "staging.nerdy-day-trips.com" > CNAME
# Adjust the url file
sed -i -e 's/https:\/\/www.nerdy-day-trips.com/https:\/\/staging.nerdy-day-trips.com/' _config.yml
sed -i -e 's/Nerdy Day Trips/Nerdy Day Trips - Staging/' _config.yml

# Build the site
bundle exec jekyll build

# Print summary
echo "Built site, total size: `du -sh ${SITE_DIR}`"

# Initialise the git repo
cd ${SITE_DIR}
# Add a file to say that the site doesn't need building
touch .nojekyll

# Setup git to push to the staging repo
git init
# Add the target remote
git remote add staging https://${NERDY_DAY_TRIPS_GITHUB_TOKEN}@github.com/fraz3alpha/nerdy-day-trips-staging.git
# Create a new branch, and commit all the code
git checkout -b gh-pages
git add -A
git commit -m 'Travis build for staging'
git log -1
git push --force staging gh-pages
