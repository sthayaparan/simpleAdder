$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$frontendDir = Join-Path $root "frontend"
$runDir = Join-Path $root "scripts\.run"
New-Item -ItemType Directory -Force -Path $runDir | Out-Null

$pidFile = Join-Path $runDir "frontend.pid"
if (Test-Path $pidFile) {
    Write-Host "Frontend already running (PID $(Get-Content $pidFile)). Run stop-frontend.ps1 first."
    exit 1
}

$process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "npm run dev" `
    -WorkingDirectory $frontendDir `
    -RedirectStandardOutput (Join-Path $runDir "frontend.out.log") `
    -RedirectStandardError (Join-Path $runDir "frontend.err.log") `
    -WindowStyle Hidden -PassThru

$process.Id | Out-File -FilePath $pidFile -Encoding ascii
Write-Host "Frontend started (PID $($process.Id)) at http://localhost:3000"
