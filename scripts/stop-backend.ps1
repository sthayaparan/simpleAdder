$root = Split-Path -Parent $PSScriptRoot
$pidFile = Join-Path $root "scripts\.run\backend.pid"

if (-not (Test-Path $pidFile)) {
    Write-Host "Backend is not running (no PID file)."
    exit 0
}

$processId = Get-Content $pidFile
taskkill /PID $processId /T /F 2>$null | Out-Null
Remove-Item $pidFile
Write-Host "Backend stopped (PID $processId)"
