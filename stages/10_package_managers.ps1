param([hashtable]$Config)

Write-Host "Stage 10: Installing language runtimes and package tools..."

function Install-PackageIfMissing {
    param(
        [string]$Command,
        [string]$WingetId
    )

    if (-not (Get-Command $Command -ErrorAction SilentlyContinue)) {
        Write-Host "$Command not found, installing via WinGet..."
        try {
            winget install --id $WingetId -e --silent --source winget
        } catch {
            Write-Host "Failed to install $Command via WinGet. Please install manually."
        }
    } else {
        Write-Host "$Command already installed: $(Get-Command $Command).Source"
    }
}

# Install Git (already checked in stage 00, but idempotent)
Install-PackageIfMissing -Command "git" -WingetId "Git.Git"

# Install Python
Install-PackageIfMissing -Command "python" -WingetId "Python.Python.3"

# Install Node.js
Install-PackageIfMissing -Command "node" -WingetId "OpenJS.NodeJS.LTS"

# Install Rust (rustup)
if (-not (Get-Command "rustc" -ErrorAction SilentlyContinue)) {
    Write-Host "Rust not found, installing via rustup..."
    Invoke-Expression "& { iwr https://sh.rustup.rs -UseBasicParsing | iex }"
} else {
    Write-Host "Rust already installed: $(rustc --version)"
}

# Install Go
Install-PackageIfMissing -Command "go" -WingetId "GoLang.Go"

Write-Host "Stage 10 complete."
