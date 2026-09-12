#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
project="$root/backend/SimpleAdder.Api/SimpleAdder.Api.csproj"
run_dir="$root/scripts/.run"
mkdir -p "$run_dir"

pid_file="$run_dir/backend.pid"
if [ -f "$pid_file" ]; then
    echo "Backend already running (PID $(cat "$pid_file")). Run stop-backend.sh first."
    exit 1
fi

dotnet build "$project" -c Debug > /dev/null
dll="$root/backend/SimpleAdder.Api/bin/Debug/net10.0/SimpleAdder.Api.dll"

(cd "$root/backend/SimpleAdder.Api" && \
    ASPNETCORE_ENVIRONMENT=Development ASPNETCORE_URLS=http://localhost:5253 \
    setsid dotnet "$dll" \
    > "$run_dir/backend.out.log" 2> "$run_dir/backend.err.log" &
echo $! > "$pid_file")

echo "Backend started (PID $(cat "$pid_file")) at http://localhost:5253"
