#!/bin/bash

set -euo pipefail

# > Even though the NAT engine separates the VM from the host, the VM has
# > access to the host's loopback interface and the network services running on
# > it. The host's loopback interface is accessible as IP address 10.0.2.2.
host_machine_loopback=10.0.2.2

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
      --reference-hostname ${host_machine_loopback} \
      --debug \
      --plan-workingdir ${directory} \
      --tests-match '*nvda.collected.json' \
      '**/*' || true

    if ! ps -p ${virtualbox_server_pid} > /dev/null; then
      echo 'Error: VirtualBox web server exited unexpectedly.' >&2

      break
    fi
  done
