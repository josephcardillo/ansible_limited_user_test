#!/bin/bash
set -e

# constants
readonly VARS_PATH="./group_vars/limiteduser/vars"

function ansible:build {
  # ssh_key
  # write vars file
  mkdir -p ${VARS_PATH}
  sed 's/  //g' <<EOF > ${VARS_PATH}
  # linode vars
  # sudo user
  sudo_username: ${SUDO_USERNAME}
EOF
}

function ansible:deploy {
  ansible-playbook -vvv provision.yml
}

# main
case $1 in
    ansible:build) "$@"; exit;;
    ansible:deploy) "$@"; exit;;
esac
