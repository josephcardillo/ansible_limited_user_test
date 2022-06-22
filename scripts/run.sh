#!/bin/bash
set -e

# constants
# readonly VARS_PATH="./group_vars/limiteduser/vars"

function ansible:build {
  ssh_key
  # write vars file
  #sed 's/  //g' <<EOF > ${VARS_PATH}
  # linode vars
  # sudo user
  #sudo_username: ${SUDO_USERNAME}
# EOF
}

function ansible:deploy {
  ansible-playbook -vvv provision.yml
}

