#!/bin/bash

# Source:
# https://www.virtualbox.org/wiki/Linux_Downloads

set -euo pipefail

. /etc/os-release

echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian ${VERSION_CODENAME} contrib" \
  >> /etc/apt/sources.list

echo Downloading and installing signing keys
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- \
  | sudo apt-key add -

echo Updating package cache
apt-get update

echo Installing package
apt-get install virtualbox-6.1
