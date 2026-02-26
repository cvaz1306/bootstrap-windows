# Tests for 00_prereqs.ps1

# Check admin
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $admin) { throw "Not running as Administrator" }

# Check Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "Git not installed" }

# Check WinGet
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw "WinGet not installed" }

Write-Host "All prerequisite tests passed."
