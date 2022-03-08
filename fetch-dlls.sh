#!/bin/bash

set -e

wget \
  --directory-prefix Assistive-Webdriver/components/text-to-socket-engine \
  'https://unpkg.com/text-to-socket-engine@0.0.3/TextToSocketEngine-x86.dll' \
  'https://unpkg.com/text-to-socket-engine@0.0.3/TextToSocketEngine-amd64.dll'
