#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
frontend_dir="$root/frontend"
run_dir="$root/scripts/.run"
mkdir -p "$run_dir"

pid_file="$run_dir/frontend.pid"
if [ -f "$pid_file" ]; then
    echo "Frontend already running (PID $(cat "$pid_file")). Run stop-frontend.sh first."
    exit 1
fi

(cd "$frontend_dir" && setsid npm run dev \
    > "$run_dir/frontend.out.log" 2> "$run_dir/frontend.err.log" &
echo $! > "$pid_file")

echo "Frontend started (PID $(cat "$pid_file")) at http://localhost:3000"
