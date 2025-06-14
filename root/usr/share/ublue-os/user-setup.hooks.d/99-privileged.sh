#!/usr/bin/env bash
set -ouex pipefail

echo "Running all privileged units"
pkexec /usr/libexec/ublue-privileged-setup
