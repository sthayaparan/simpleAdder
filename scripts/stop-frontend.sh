#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
pid_file="$root/scripts/.run/frontend.pid"

if [ ! -f "$pid_file" ]; then
    echo "Frontend is not running (no PID file)."
    exit 0
fi

pid="$(cat "$pid_file")"
kill -- "-$pid" 2>/dev/null || kill "$pid" 2>/dev/null || true
rm -f "$pid_file"
echo "Frontend stopped (PID $pid)"
