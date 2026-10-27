
$ErrorActionPreference = "Stop"

$GitHubUser = "keshavp07-git"
$Registry = "ghcr.io"
$SourceDir = Join-Path $PSScriptRoot "src"

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw "Docker command not found. Start Docker Desktop and check your installation."
}

docker info | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw "Docker is not running. Start Docker Desktop and retry."
}

if (-not (Test-Path $SourceDir)) {
    throw "src directory not found: $SourceDir"
}

$Success = 0
$Failed = 0
$Skipped = 0

Get-ChildItem $SourceDir -Directory | ForEach-Object {
    $Service = $_.Name.ToLowerInvariant()
    $Dockerfile = Join-Path $_.FullName "Dockerfile"
    $Image = "${Registry}/${GitHubUser}/${Service}:latest"

    if (-not (Test-Path $Dockerfile)) {
        Write-Host "SKIP: $Service has no Dockerfile" -ForegroundColor Yellow
        $Skipped++
        return
    }

    Write-Host "`n========== BUILDING $Service ==========" -ForegroundColor Cyan

    docker build -t $Image $_.FullName

    if ($LASTEXITCODE -ne 0) {
        Write-Host "BUILD FAILED: $Service" -ForegroundColor Red
        $Failed++
        return
    }

    Write-Host "PUSHING: $Image" -ForegroundColor Cyan

    docker push $Image

    if ($LASTEXITCODE -ne 0) {
        Write-Host "PUSH FAILED: $Service" -ForegroundColor Red
        $Failed++
        return
    }

    Write-Host "SUCCESS: $Image" -ForegroundColor Green
    $Success++
}

Write-Host "`n========== SUMMARY ==========" -ForegroundColor Cyan
Write-Host "Successfully pushed: $Success"
Write-Host "Failed:              $Failed"
Write-Host "Skipped:             $Skipped"
