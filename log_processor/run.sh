#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "=== Linux evidence ==="
lsb_release -a
uname -a
elixir -v
echo "CPU cores: $(nproc)"
free -h

echo
echo "=== Running tests ==="
mix test

echo
echo "=== Running the concurrent log processor ==="
mix run -e 'LogProcessor.demo()'