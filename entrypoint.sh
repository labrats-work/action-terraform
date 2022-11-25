#!/bin/sh -l

set -e
set -o pipefail

# get version
terraformVersion=$(terraform version | head -n 1 | cut -d ' ' -f 2)
# output terraformVersion
echo "terraformVersion=$terraformVersion" >> $GITHUB_OUTPUT

# Evaluate keyfile
if [ ! -z "$INPUT_SSHKEY" ]
then
  echo "\$INPUT_SSHKEY is set. Starting ssh-agent and adding to key collection."
  eval `ssh-agent`
  echo "${INPUT_SSHKEY}" | ssh-add -
else
  echo "\$INPUT_SSHKEY not set. You'll most probably only be able to work on localhost."
fi