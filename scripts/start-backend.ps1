$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$project = Join-Path $root "backend\SimpleAdder.Api\SimpleAdder.Api.csproj"
$runDir = Join-Path $root "scripts\.run"
New-Item -ItemType Directory -Force -Path $runDir | Out-Null

$pidFile = Join-Path $runDir "backend.pid"
if (Test-Path $pidFile) {
    Write-Host "Backend already running (PID $(Get-Content $pidFile)). Run stop-backend.ps1 first."
    exit 1
}

dotnet build $project -c Debug | Out-Null
$dll = Join-Path $root "backend\SimpleAdder.Api\bin\Debug\net10.0\SimpleAdder.Api.dll"

$env:ASPNETCORE_ENVIRONMENT = "Development"
$env:ASPNETCORE_URLS = "http://localhost:5253"

$process = Start-Process -FilePath "dotnet" -ArgumentList "`"$dll`"" `
    -WorkingDirectory (Join-Path $root "backend\SimpleAdder.Api") `
    -RedirectStandardOutput (Join-Path $runDir "backend.out.log") `
    -RedirectStandardError (Join-Path $runDir "backend.err.log") `
    -WindowStyle Hidden -PassThru

$process.Id | Out-File -FilePath $pidFile -Encoding ascii
Write-Host "Backend started (PID $($process.Id)) at http://localhost:5253"
