#!/bin/bash
set -e

STOP_LOOP="false"

echo "Vertica container is now running"

/usr/sbin/sshd -D

# while [ "${STOP_LOOP}" == "false" ]; do
#  sleep 1
# done
