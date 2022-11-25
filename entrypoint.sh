#!/bin/sh -l

set -e
set -o pipefail

# get version
terraformVersion=$(terraform version | head -n 1 | cut -d ' ' -f 2)
# output terraformVersion
echo "terraformVersion=$terraformVersion" >> $GITHUB_OUTPUT

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
echo terraform ${VERB} --var-file=default.tfvars
terraform init
terraform ${VERB} --var-file=default.tfvars