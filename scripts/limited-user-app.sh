#!/bin/bash
set -e

## Deployment Variables
#<UDF name="sudo_username" label="The limited sudo user to be created on the Linode" />

# git repo
export GIT_REPO="https://github.com/josephcardillo/ansible_limited_user_test.git"

# enable logging
exec > >(tee /dev/ttyS0 /var/log/stackscript.log) 2>&1

# source script libraries
source <ssinclude StackScriptID=1>

function setup {
  # install dependancies
  apt-get update
  apt-get install -y jq git python3 python3-pip python3-dev build-essential
  # write authorized_keys file
  if [ "${ADD_SSH_KEYS}" == "yes" ]; then
    curl -sH "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN_PASSWORD}" https://api.linode.com/v4/profile/sshkeys | jq -r .data[].ssh_key > /root/.ssh/authorized_keys
  fi
  # clone repo and set up ansible environment
  git clone ${GIT_REPO} /tmp/sudo-user
  cd /tmp/sudo-user
  pip3 install virtualenv
  python3 -m virtualenv env
  source env/bin/activate
  pip install pip --upgrade
  pip install -r requirements.txt
  ansible-galaxy install -r collections.yml
  # copy run script to path
  cp scripts/run.sh /usr/local/bin/run
  chmod +x /usr/local/bin/run
}
# main
setup
run ansible:build
run ansible:deploy && export SUCCESS="true"
