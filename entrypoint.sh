#!/bin/sh -l

set -e
set -o pipefail

# get version
terraformVersion=$(terraform version | head -n 1 | cut -d ' ' -f 2)

export TF_CHDIR=""
export TF_VERB="apply"
export TF_AUTOAPPROVE=""
export TF_OUT=""
export TF_VARSFILE=
export TF_BACKEND=
export TF_PLAN=
export TF_INPUT="-input=false"

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

# Evaluate INPUT_CHDIR
if [ ! -z "$INPUT_CHDIR" ]
then
  echo "\$INPUT_CHDIR is set. Using $INPUT_CHDIR."
  export TF_CHDIR="-chdir=$INPUT_CHDIR"
fi

# Evaluate INPUT_BACKENDCONFIGFILE
if [ ! -z "$INPUT_BACKENDCONFIGFILE" ]
then
  echo "\$INPUT_BACKENDCONFIGFILE is set. Using $INPUT_BACKENDCONFIGFILE."
  export TF_BACKEND="-backend-config=$INPUT_BACKENDCONFIGFILE"
fi

# Evaluate INPUT_VERB
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

if [ "$TF_VERB" = "apply" ] || [ "$TF_VERB" = "destroy" ] 
then
  export TF_AUTOAPPROVE="-auto-approve"
fi

if [ "$TF_VERB" = "plan" ]
then
  export TF_OUT="-out=tfplan"
fi

# Evaluate INPUT_VARSFILE
if [ ! -z "$INPUT_VARSFILE" ]
then
  echo "\$INPUT_VARSFILE is set. Using $INPUT_VARSFILE."
  export TF_VARSFILE="--var-file=$INPUT_VARSFILE"
fi

# Evaluate INPUT_PLANFILE
if [ "$TF_VERB" = "apply" ] && [ ! -z "$INPUT_PLANFILE" ]
then
  export TF_PLAN="$INPUT_PLANFILE"
  export TF_OUT=
  export TF_VARSFILE=
  export TF_AUTOAPPROVE=
  export TF_INPUT=
fi

# Evaluate INPUT_INIT
if [ ! -z "$INPUT_INIT" ] && [ ! "$INPUT_INIT" = "no" ]
then
  echo "\$INPUT_INIT is set to $INPUT_INIT. Will execute terraform init."
  echo terraform ${TF_CHDIR} init ${TF_BACKEND}
  terraform ${TF_CHDIR} init ${TF_BACKEND}
fi

echo "going to execute: "
echo terraform ${TF_CHDIR} ${TF_VERB} ${TF_PLAN} ${TF_VARSFILE} ${TF_AUTOAPPROVE} ${TF_OUT} ${TF_INPUT}
terraform ${TF_CHDIR} ${TF_VERB} ${TF_PLAN} ${TF_VARSFILE} ${TF_AUTOAPPROVE} ${TF_OUT} ${TF_INPUT}
STATUS_TF="$?"

# Copy $INPUT_PLANFILE to github workspace
if [ "$TF_VERB" = "plan" ]
then
    #
    # https://developer.hashicorp.com/terraform/cli/commands/plan
    # 0 = Succeeded with empty diff (no changes)
    # 1 = Error
    # 2 = Succeeded with non-empty diff (changes present)
    #
    if [ "$STATUS_TF" = "0" ] || [ "$STATUS_TF" = "2" ]
    then
      exit 0
    fi
fi