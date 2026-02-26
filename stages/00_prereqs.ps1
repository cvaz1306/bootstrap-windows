param([hashtable]$Config)

function Ensure-Command {
    param([string]$Command, [string]$InstallHint)
    if (-not (Get-Command $Command -ErrorAction SilentlyContinue)) {
        Write-Host "$Command not found. $InstallHint" -ForegroundColor Yellow
        throw "$Command missing"
    } else {
        Write-Host "$Command found: $(Get-Command $Command).Source" -ForegroundColor Green
    }
}

# Check admin rights
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    throw "Script must be run as Administrator."
}

# Execution policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force

# Ensure basic commands
Ensure-Command "git" "Install Git from https://git-scm.com/download/win"
Ensure-Command "winget" "Install WinGet via Microsoft Store or App Installer"

Write-Host "Prerequisites check passed."
