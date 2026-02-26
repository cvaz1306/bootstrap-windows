# bootstrap.ps1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$LogFile = "$PSScriptRoot\logs\bootstrap.log"
if (-not (Test-Path $PSScriptRoot\logs)) { New-Item -ItemType Directory -Path $PSScriptRoot\logs }

function Log {
    param([string]$Message)
    $Message | Tee-Object -FilePath $LogFile -Append
}

# Load config
$config = Import-PowerShellDataFile "$PSScriptRoot\config.psd1"

# Discover stages
$Stages = Get-ChildItem "$PSScriptRoot\stages\*.ps1" | Sort-Object Name

foreach ($stage in $Stages) {
    Write-Host "`n=== Running stage $($stage.Name) ===" -ForegroundColor Cyan
    Log "=== Running stage $($stage.Name) ==="

    try {
        # Execute stage
        & $stage.FullName -Config $config
    } catch {
        Log "ERROR in $($stage.Name): $_"
        throw
    }

    # Run stage tests
    $testFile = "$PSScriptRoot\tests\$($stage.BaseName).Tests.ps1"
    if (Test-Path $testFile) {
        Write-Host "Running tests for $($stage.BaseName)..."
        Log "Running tests for $($stage.BaseName)"
        & $testFile
    } else {
        Write-Host "No tests found for $($stage.BaseName)"
    }
}
