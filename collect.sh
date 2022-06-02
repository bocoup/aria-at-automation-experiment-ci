#!/bin/bash

set -euo pipefail

# > Even though the NAT engine separates the VM from the host, the VM has
# > access to the host's loopback interface and the network services running on
# > it. The host's loopback interface is accessible as IP address 10.0.2.2.
host_machine_loopback=10.0.2.2

# https://docs.oracle.com/en/virtualization/virtualbox/6.0/admin/vboxwebsrv-daemon.html
virtualbox_server_address=localhost:18083

# > The Oracle VM VirtualBox web service, vboxwebsrv, is used for controlling
# > Oracle VM VirtualBox remotely.
#
# https://docs.oracle.com/en/virtualization/virtualbox/6.0/admin/vboxwebsrv-daemon.html
vboxwebsrv --authentication null > /dev/null &

virtualbox_server_pid=$!

function kill_virtualbox_server {
  kill -9 ${virtualbox_server_pid}
}

function verify_virtualbox_server_running {
  if ! ps -p ${virtualbox_server_pid} > /dev/null; then
    echo 'Error: VirtualBox web server exited unexpectedly.' >&2

    exit 1
  fi
}

function is_virtualbox_server_ready {
  curl \
    --silent \
    --output /dev/null \
    --write-out '%{http_code}\n' \
    ${virtualbox_server_address} |
    grep --silent -E '^4'
}

echo Waiting for VirtualBox server to become available

while true ; do
  if is_virtualbox_server_ready; then
    break;
  fi

  verify_virtualbox_server_running
done


trap kill_virtualbox_server EXIT

echo Collecting results

find aria-at/build/tests/ -mindepth 1 -maxdepth 1 -type d -print0 |
  while IFS= read -r -d '' directory; do
    if [ "${directory}" != 'aria-at/build/tests/checkbox' ]; then
      continue
    fi

    ./aria-at-automation-harness/bin/host.js \
      run-plan \
      --reference-hostname ${host_machine_loopback} \
      --debug \
      --plan-workingdir ${directory} \
      --tests-match "*-voiceover_macos.collected.json" \
      '**/*' || true

    verify_virtualbox_server_running
  done
