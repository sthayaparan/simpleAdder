$root = Split-Path -Parent $PSScriptRoot
$pidFile = Join-Path $root "scripts\.run\frontend.pid"

if (-not (Test-Path $pidFile)) {
    Write-Host "Frontend is not running (no PID file)."
    exit 0
}

$processId = Get-Content $pidFile
taskkill /PID $processId /T /F 2>$null | Out-Null
Remove-Item $pidFile
Write-Host "Frontend stopped (PID $processId)"
