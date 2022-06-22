#!/bin/bash
set -e

function ansible:build {
  ssh_key
  # write vars file
  sed 's/  //g' <<EOF > ${VARS_PATH}
  # linode vars
  # sudo user
  sudo_username: ${SUDO_USERNAME}
EOF
}

function ansible:deploy {
  ansible-playbook -vvv provision.yml
}

