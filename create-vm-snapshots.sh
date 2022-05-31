#!/bin/bash

set -e

if vagrant snapshot list | grep root &> /dev/null ; then
  echo "Snapshot root already exists"
else
  echo "Creating VM from scratch"
  vagrant destroy -f
  vagrant up
  vagrant halt
  vagrant snapshot save root
fi
