# Hugo Local Development Test Script for Windows PowerShell
# Run this script from the Hugo site directory: D:\thenerdofalltrades_website\thenerdofalltrades.com

Write-Host "Hugo Local Development Test Script" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green
Write-Host ""

# Check if we're in the right directory
$currentDir = Get-Location
Write-Host "Current directory: $currentDir" -ForegroundColor Yellow

# Check for essential files
$configExists = Test-Path "config.toml"
$themeExists = Test-Path "themes\PaperMod"
$contentExists = Test-Path "content"

Write-Host ""
Write-Host "File Structure Check:" -ForegroundColor Cyan
Write-Host "  config.toml exists: $configExists" -ForegroundColor $(if($configExists){"Green"}else{"Red"})
Write-Host "  PaperMod theme exists: $themeExists" -ForegroundColor $(if($themeExists){"Green"}else{"Red"})
Write-Host "  content directory exists: $contentExists" -ForegroundColor $(if($contentExists){"Green"}else{"Red"})

if (-not $configExists) {
    Write-Host ""
    Write-Host "ERROR: config.toml not found!" -ForegroundColor Red
    Write-Host "Make sure you're in the correct directory: D:\thenerdofalltrades_website\thenerdofalltrades.com" -ForegroundColor Red
    exit 1
}

if (-not $themeExists) {
    Write-Host ""
    Write-Host "ERROR: PaperMod theme not found!" -ForegroundColor Red
    Write-Host "Run: git submodule add https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod" -ForegroundColor Yellow
    exit 1
}

# Check Hugo version
Write-Host ""
Write-Host "Checking Hugo installation..." -ForegroundColor Cyan
try {
    $hugoVersion = hugo version
    Write-Host "  Hugo version: $hugoVersion" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Hugo not found in PATH!" -ForegroundColor Red
    Write-Host "  Install Hugo and add to PATH: https://github.com/gohugoio/hugo/releases" -ForegroundColor Yellow
    exit 1
}

# Test Hugo configuration
Write-Host ""
Write-Host "Testing Hugo configuration..." -ForegroundColor Cyan
try {
    $configTest = hugo config 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Configuration test: PASSED" -ForegroundColor Green
    } else {
        Write-Host "  Configuration test: FAILED" -ForegroundColor Red
        Write-Host "  Error output:" -ForegroundColor Red
        Write-Host $configTest -ForegroundColor Red
        Write-Host ""        Write-Host "  Common fixes for Hugo v0.147.9+:" -ForegroundColor Yellow
        Write-Host "  1. Use [pagination] pagerSize = 5 instead of paginate = 5" -ForegroundColor Yellow
        Write-Host "  2. Ensure theme = 'PaperMod' (with quotes)" -ForegroundColor Yellow
        Write-Host "  3. Check for other deprecated config keys" -ForegroundColor Yellow
        Write-Host "  4. Check for hidden characters or encoding issues" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "  Configuration test: ERROR" -ForegroundColor Red
    Write-Host "  Error: $_" -ForegroundColor Red
    exit 1
}

# Start Hugo server
Write-Host ""
Write-Host "Starting Hugo development server..." -ForegroundColor Cyan
Write-Host "  Command: hugo server -D" -ForegroundColor Yellow
Write-Host "  Site will be available at: http://localhost:1313" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop the server when done testing" -ForegroundColor Magenta
Write-Host ""

# Start the server
hugo server -D
