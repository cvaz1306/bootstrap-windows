# Tests for 10_package_managers.ps1
# Run in a new PowerShell process to pick up updated PATH

$tools = @("git", "python", "node", "go", "rustc")

# Determine available PowerShell executable
$psExe = if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    "pwsh"
} elseif (Get-Command powershell -ErrorAction SilentlyContinue) {
    "powershell"
} else {
    throw "No PowerShell executable found"
}

$psCommand = {
    param($tools)
    foreach ($tool in $tools) {
        if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
            throw "$tool is not installed"
        } else {
            Write-Host "$tool OK: $($tool) found at $(Get-Command $tool).Source"
        }
    }
    Write-Host "All package manager tests passed."
}

# Start a new PowerShell process for the test
Start-Process $psExe -ArgumentList "-NoProfile", "-Command & { & $psCommand -tools $using:tools }" -Wait
