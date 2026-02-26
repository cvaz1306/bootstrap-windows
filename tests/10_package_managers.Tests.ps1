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

# Build the script block for the new process
$script = {
    param($tools)
    foreach ($tool in $tools) {
        if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
            throw "$tool is not installed"
        } else {
            Write-Host "$tool OK: $((Get-Command $tool).Source)"
        }
    }
    Write-Host "All package manager tests passed."
}

# Encode the script for safe passing
$bytes = [System.Text.Encoding]::Unicode.GetBytes("param(`$tools) `n " + ($script.ToString()))
$encoded = [Convert]::ToBase64String($bytes)

# Start a new PowerShell process with -EncodedCommand
Start-Process $psExe -ArgumentList "-NoProfile", "-EncodedCommand $encoded" -Wait -PassThru
