#!/bin/bash

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
