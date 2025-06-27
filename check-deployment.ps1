# Pre-deployment verification script
# Checks that all required files are in place before deploying

Write-Host "🔍 TheNerdOfAllTrades.com Pre-Deployment Check" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

Set-Location "c:\Users\cliguz\Documents\Chris_Personal\Website\site"

$errors = @()
$warnings = @()

# Check required files
$requiredFiles = @(
    "config.toml",
    "content\_index.md",
    "content\about.md",
    "content\posts\welcome-to-the-nerd-of-all-trades.md",
    ".github\workflows\hugo.yml"
)

Write-Host "`n📋 Checking required files..." -ForegroundColor Yellow
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        Write-Host "❌ $file" -ForegroundColor Red
        $errors += "Missing required file: $file"
    }
}

# Check theme
Write-Host "`n🎨 Checking theme..." -ForegroundColor Yellow
if (Test-Path "themes\PaperMod") {
    Write-Host "✅ PaperMod theme found" -ForegroundColor Green
} else {
    Write-Host "❌ PaperMod theme missing" -ForegroundColor Red
    $errors += "PaperMod theme not found in themes/ directory"
}

# Check git configuration
Write-Host "`n📁 Checking git configuration..." -ForegroundColor Yellow
if (Test-Path ".git") {
    Write-Host "✅ Git repository initialized" -ForegroundColor Green
    
    $remoteUrl = git remote get-url origin 2>$null
    if ($remoteUrl) {
        Write-Host "✅ Remote repository configured: $remoteUrl" -ForegroundColor Green
    } else {
        Write-Host "⚠️ No remote repository configured" -ForegroundColor Yellow
        $warnings += "Remote repository not configured"
    }
} else {
    Write-Host "❌ Git repository not initialized" -ForegroundColor Red
    $errors += "Git repository not initialized"
}

# Check config.toml for common issues
Write-Host "`n⚙️ Checking config.toml..." -ForegroundColor Yellow
if (Test-Path "config.toml") {
    $configContent = Get-Content "config.toml" -Raw
    
    if ($configContent -match 'baseURL\s*=\s*["\']https?://.*["\']') {
        Write-Host "✅ baseURL configured" -ForegroundColor Green
    } else {
        Write-Host "⚠️ baseURL may need updating" -ForegroundColor Yellow
        $warnings += "Check baseURL in config.toml"
    }
    
    if ($configContent -match 'theme\s*=\s*["\']PaperMod["\']') {
        Write-Host "✅ PaperMod theme set in config" -ForegroundColor Green
    } else {
        Write-Host "❌ PaperMod theme not set in config" -ForegroundColor Red
        $errors += "Theme not set to PaperMod in config.toml"
    }
}

# Check content front matter
Write-Host "`n📝 Checking content..." -ForegroundColor Yellow
$postFile = "content\posts\welcome-to-the-nerd-of-all-trades.md"
if (Test-Path $postFile) {
    $postContent = Get-Content $postFile -Raw
    if ($postContent -match 'draft:\s*false') {
        Write-Host "✅ Welcome post is not a draft" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Welcome post may be marked as draft" -ForegroundColor Yellow
        $warnings += "Check if welcome post is marked as draft"
    }
}

# Summary
Write-Host "`n📊 SUMMARY" -ForegroundColor Cyan
Write-Host "==========" -ForegroundColor Cyan

if ($errors.Count -eq 0) {
    Write-Host "✅ No critical errors found!" -ForegroundColor Green
    Write-Host "`nYou can proceed with deployment using: .\deploy-site.ps1" -ForegroundColor White
} else {
    Write-Host "❌ Critical errors found:" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host "  • $error" -ForegroundColor Red
    }
    Write-Host "`nPlease fix these errors before deploying." -ForegroundColor Yellow
}

if ($warnings.Count -gt 0) {
    Write-Host "`n⚠️ Warnings:" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  • $warning" -ForegroundColor Yellow
    }
}

Write-Host "`n🔧 Quick fixes:" -ForegroundColor Cyan
Write-Host "• To initialize git: git init" -ForegroundColor White
Write-Host "• To add remote: git remote add origin https://github.com/USERNAME/TheNerdOfAllTrades.com.git" -ForegroundColor White
Write-Host "• To install theme: git submodule add https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod" -ForegroundColor White
