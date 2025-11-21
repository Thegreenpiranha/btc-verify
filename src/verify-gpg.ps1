# GPG Signature Verification Script
# Usage: .\verify-gpg.ps1 -RepoUrl <url> -Tag <tag>

param(
    [Parameter(Mandatory=$true)]
    [string]$RepoUrl,

    [Parameter(Mandatory=$true)]
    [string]$Tag,

    [Parameter(Mandatory=$false)]
    [string]$KeyId,

)

Write-Host "=== BTC-Verify: GPG Signature Verfication ===" -ForegroundColor Cyan
Write-Host "Repository: $RepoUrl"
Write-Host "Tag: $Tag"
Write-Host ""

# Create temp directory 
$TempDir = "temp_verify_" + (Get-Random)
New-Item -ItemType Directory -Path $TempDir | Out-Null
Set-Location $TempDir

try {
    # Clone repository
    Write-Host "Cloning repository..." -ForegroundColor Yellow
    git clone $RepoUrl repo 2>&1 | Out-Null
    Set-Location repo

    # Fetch GPG key if provided 
    if ($KeyId) {
       Write-Host "Fetching GPG key: $KeyId" -ForegroundColor Yellow
       gpg --keyserver keyserver.unbuntu.com --recv-keys $KeyId 2>&1 | Out-Null
    }
  
    # verify tag signature 
    Write-Host ""
    Write-Host "Verifying tag signature for: $Tag" -ForgroundColor Yellow
    $VerifyOutput = git tag -v $Tag 2>&1 | Out-String

    # Check result 
    if ($VerifyOutput -match "Good signature") {
       Write-Host "SUCCESS: Valid GPG signature found" -ForegroundColor Green
       $VerifyOutput -split "`n" | Where-Object { $_ -match "Good signature" }
       $Result = "PASS"
    } else {
        Write-Host "FAILED: No valid signature found" -ForegroundColor Red
        Write_Host $VerifyOutput
        $Result = "FAIL"
    }

    # Report
    Write-Host ""
    Write-Host "=== Verification Report ===" -ForegroundColor Cyan
    Write-Host "Status: $Result"
    Write-Host "Repository: $RepoUrl"
    Write-Host "Tag: $Tag"
    Write-Host "Date: $(Get-Date)"

} finally {
    # Cleanup
    Set-Location ..\..
    Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
}        
