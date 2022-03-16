#!/bin/bash

# > The Oracle VM VirtualBox web service, vboxwebsrv, is used for controlling
# > Oracle VM VirtualBox remotely.
#
# https://docs.oracle.com/en/virtualization/virtualbox/6.0/admin/vboxwebsrv-daemon.html
vboxwebsrv --authentication null &

virtualbox_server_pid=$!

function kill_virtualbox_server {
  kill -9 ${virtualbox_server_pid}
}

trap kill_virtualbox_server EXIT

find aria-at/build/tests/ -mindepth 1 -maxdepth 1 -type d -print0 |
  while IFS= read -r -d '' directory; do
    ./aria-at-automation-harness/bin/host.js \
      run-plan \
      --reference-hostname 10.0.2.2 \
      --debug \
      --plan-workingdir ${directory} \
      --tests-match '*nvda.collected.json' \
      '**/*'
  done
