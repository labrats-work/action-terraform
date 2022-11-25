#!/bin/sh -l

set -e
set -o pipefail

# get version
terraformVersion=$(terraform version | head -n 1 | cut -d ' ' -f 2)
# output terraformVersion
echo "ansibleVersion=$terraformVersion" >> $GITHUB_OUTPUT