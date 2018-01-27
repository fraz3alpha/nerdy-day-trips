#!/usr/bin/env bash

# Enable exit on failure
set -e

# based on https://jekyllrb.com/docs/continuous-integration/travis-ci/

SITE_DIR=_site

# Clear out the build directory
rm -rf ${SITE_DIR} && mkdir ${SITE_DIR}

# Build the site
bundle exec jekyll build

# Print summary
echo "Built site, total size: `du -sh ${SITE_DIR}`"

# Initialise the git repo
#cd ${SITE_DIR}
#git init
# Add the target remote
#git remote add origin
