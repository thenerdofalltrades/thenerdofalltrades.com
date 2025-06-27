# Deploy Hugo Site to GitHub Pages
# This script will commit all changes and push to GitHub to trigger deployment

Write-Host "🚀 TheNerdOfAllTrades.com Deployment Script" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# Navigate to the site directory
Set-Location "c:\Users\cliguz\Documents\Chris_Personal\Website\site"

# Check if we're in a git repository
if (-not (Test-Path ".git")) {
    Write-Host "❌ Error: Not in a git repository. Please run 'git init' first." -ForegroundColor Red
    exit 1
}

Write-Host "📝 Checking git status..." -ForegroundColor Yellow
git status

Write-Host "`n📁 Adding all files to git..." -ForegroundColor Yellow
git add .

Write-Host "`n📋 Current files to be committed:" -ForegroundColor Yellow
git status --porcelain

Write-Host "`n💾 Committing changes..." -ForegroundColor Yellow
$commitMessage = "Deploy Hugo site with PaperMod theme and GitHub Actions workflow"
git commit -m $commitMessage

Write-Host "`n🔗 Checking remote repository..." -ForegroundColor Yellow
$remoteUrl = git remote get-url origin 2>$null
if ($remoteUrl) {
    Write-Host "Remote URL: $remoteUrl" -ForegroundColor Cyan
} else {
    Write-Host "❌ No remote repository configured. Please add remote first:" -ForegroundColor Red
    Write-Host "git remote add origin https://github.com/YOUR_USERNAME/TheNerdOfAllTrades.com.git" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n🚀 Pushing to GitHub (this will trigger the deployment)..." -ForegroundColor Yellow
git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Successfully pushed to GitHub!" -ForegroundColor Green
    Write-Host "`n📊 Next steps:" -ForegroundColor Cyan
    Write-Host "1. Check GitHub Actions at: https://github.com/YOUR_USERNAME/TheNerdOfAllTrades.com/actions" -ForegroundColor White
    Write-Host "2. Wait for deployment to complete (usually 2-5 minutes)" -ForegroundColor White
    Write-Host "3. Visit your site at: https://YOUR_USERNAME.github.io/TheNerdOfAllTrades.com" -ForegroundColor White
    Write-Host "4. Enable 'Enforce HTTPS' in GitHub Pages settings once SSL is ready" -ForegroundColor White
    Write-Host "5. Test your custom domain: https://thenerdofalltrades.com" -ForegroundColor White
} else {
    Write-Host "`n❌ Error pushing to GitHub. Please check your credentials and try again." -ForegroundColor Red
    Write-Host "You may need to authenticate with GitHub CLI or set up a personal access token." -ForegroundColor Yellow
}

Write-Host "`n🔍 Deployment verification commands:" -ForegroundColor Cyan
Write-Host "git log --oneline -5  # Check recent commits" -ForegroundColor White
Write-Host "git remote -v         # Verify remote repository" -ForegroundColor White
Write-Host "git branch -a         # Check branches" -ForegroundColor White
