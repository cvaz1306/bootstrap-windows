# Tests for 10_package_managers.ps1

$tools = @("git", "python", "node", "rustc", "go")

foreach ($tool in $tools) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        throw "$tool is not installed"
    } else {
        Write-Host "$tool OK: $($tool) found at $(Get-Command $tool).Source"
    }
}

Write-Host "All package manager tests passed."
