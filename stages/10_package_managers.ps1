param([hashtable]$Config)

Write-Host "Stage 10: Installing language runtimes and package tools..."

function Test-CommandInNewProcess {
    param([string]$Command)

    # Pick a PowerShell executable
    $psExe = if (Get-Command pwsh -ErrorAction SilentlyContinue) {
        "pwsh"
    } elseif (Get-Command powershell -ErrorAction SilentlyContinue) {
        "powershell"
    } else {
        throw "No PowerShell executable found"
    }

    $psCmd = "if (-not (Get-Command $Command -ErrorAction SilentlyContinue)) { exit 1 } else { exit 0 }"
    $proc = Start-Process $psExe -ArgumentList "-NoProfile","-Command $psCmd" -Wait -PassThru
    return $proc.ExitCode -eq 0
}
function Install-PackageIfMissing {
    param([string]$Command, [string]$WingetId)

    if (-not (Test-CommandInNewProcess -Command $Command)) {
        Write-Host "$Command not found, installing via WinGet..."
        try {
            winget install --id $WingetId -e --silent --source winget
        } catch {
            Write-Host "Failed to install $Command via WinGet. Please install manually."
        }
    } else {
        Write-Host "$Command already installed."
    }
}

# Git
Install-PackageIfMissing -Command "git" -WingetId "Git.Git"

# Python
Install-PackageIfMissing -Command "python" -WingetId "Python.Python.3"

# Node.js
Install-PackageIfMissing -Command "node" -WingetId "OpenJS.NodeJS.LTS"

# Go
Install-PackageIfMissing -Command "go" -WingetId "GoLang.Go"

# Rust
if (-not (Test-CommandInNewProcess -Command "rustc")) {
    Write-Host "Rust not found, installing via official Windows installer..."
    $rustInstaller = "$env:TEMP\rustup-init.exe"
    Invoke-WebRequest -Uri "https://win.rustup.rs/x86_64" -OutFile $rustInstaller -UseBasicParsing
    Start-Process -FilePath $rustInstaller -ArgumentList "-y" -Wait
    Write-Host "Rust installation complete."
} else {
    Write-Host "Rust already installed."
}

Write-Host "Stage 10 complete."
