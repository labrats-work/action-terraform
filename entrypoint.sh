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
# Evaluate workingdirectory
if [ ! -z "$INPUT_WORKINGDIRECTORY" ]
then
  echo "\$INPUT_WORKINGDIRECTORY is set. Changing working directory."
  cd $INPUT_WORKINGDIRECTORY
fi

export VERB="apply"
if [ ! -z "$INPUT_VERB" ]
then
  echo "\$INPUT_VERB is set to ${INPUT_VERB}."
    case "$INPUT_VERB" in
        "plan") export VERB="plan" 
        ;;
        "apply") export VERB="apply" 
        ;;
        "destroy") export VERB="destroy" 
        ;;
    esac
else
  echo "\$INPUT_VERB not set."
  exit 1
fi

echo "going to execute: "
echo terraform ${VERB} --var-file=default.tfvars -auto-approve
terraform init
terraform ${VERB} --var-file=default.tfvars -auto-approve
