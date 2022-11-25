#!/bin/sh -l

set -e
set -o pipefail

# get version
terraformVersion=$(terraform version | head -n 1 | cut -d ' ' -f 2)
# output terraformVersion
echo "terraformVersion=$terraformVersion" >> $GITHUB_OUTPUT

# Evaluate INPUT_SSHKEY
if [ ! -z "$INPUT_SSHKEY" ]
then
  echo "\$INPUT_SSHKEY is set. Starting ssh-agent and adding to key collection."
  eval `ssh-agent`
  echo "${INPUT_SSHKEY}" | ssh-add -
else
  echo "\$INPUT_SSHKEY not set. You'll most probably only be able to work on localhost."
fi

# Evaluate INPUT_WORKINGDIRECTORY
if [ ! -z "$INPUT_WORKINGDIRECTORY" ]
then
  echo "\$INPUT_WORKINGDIRECTORY is set. Changing working directory."
  cd $INPUT_WORKINGDIRECTORY
fi

# Evaluate INPUT_VERB
export TF_VERB="apply"
if [ ! -z "$INPUT_VERB" ]
then
  echo "\$INPUT_VERB is set to ${INPUT_VERB}."
    case "$INPUT_VERB" in
        "plan") export TF_VERB="plan" 
        ;;
        "apply") export TF_VERB="apply" 
        ;;
        "destroy") export TF_VERB="destroy" 
        ;;
    esac
else
  echo "\$INPUT_VERB not set."
  exit 1
fi

export TF_AUTOAPPROVE=""
if [ "$TF_VERB" = "apply" ] || [ "$TF_VERB" = "destroy" ] 
then
  export TF_AUTOAPPROVE="-auto-approve"
fi

export TF_OUT=""
if [ "$TF_VERB" = "plan" ]
then
  export TF_OUT="-out=$INPUT_PLANFILE"
fi

# Evaluate INPUT_VARSFILE
export TF_VARSFILE=
if [ ! -z "$INPUT_VARSFILE" ]
then
  echo "\$INPUT_VARSFILE is set. Using $INPUT_VARSFILE."
  export TF_VARSFILE="--var-file=$INPUT_VARSFILE"
fi

# Evaluate INPUT_PLANFILE
export TF_PLAN=
if [ ! -z "$INPUT_PLANFILE" ] && [ "$TF_VERB" = "apply" ]
then
  echo "\$INPUT_PLANFILE is set. Using $INPUT_PLANFILE."
  [ -f /github/workspace/$INPUT_PLANFILE ] && [ ! -f $INPUT_PLANFILE ] && cp /github/workspace/$INPUT_PLANFILE $INPUT_PLANFILE
  if [ -f "$INPUT_PLANFILE" ]
  then
    export TF_PLAN="$INPUT_PLANFILE"
    export TF_OUT=
    export TF_VARSFILE=
    export TF_AUTOAPPROVE=
  else
    echo "\$INPUT_PLANFILE $INPUT_PLANFILE does not exist in the current context."
    exit 1
  fi
fi

# Evaluate INPUT_INIT
if [ ! -z "$INPUT_INIT" ] && [ "$INPUT_INIT" = "yes" ]
then
  echo "\$INPUT_INIT is set to $INPUT_INIT. Will execute terraform init."
  echo terraform init
  terraform init
fi

echo "going to execute: "
echo terraform ${TF_VERB} ${TF_PLAN} ${TF_VARSFILE} ${TF_AUTOAPPROVE} ${TF_OUT}

if [ "$TF_VERB" = "plan" ]
then
  # TODO, better way of handling exit code 2 & 3 with set -e
  terraform ${TF_VERB} ${TF_PLAN} ${TF_VARSFILE} ${TF_AUTOAPPROVE} ${TF_OUT} || :
else
  terraform ${TF_VERB} ${TF_PLAN} ${TF_VARSFILE} ${TF_AUTOAPPROVE} ${TF_OUT}
fi

# Copy $INPUT_PLANFILE to github workspace
if [ "$TF_VERB" = "plan" ]
then
    [ -f $INPUT_PLANFILE ] && [ ! -f /github/workspace/$INPUT_PLANFILE ] && cp $INPUT_PLANFILE /github/workspace/$INPUT_PLANFILE
fi