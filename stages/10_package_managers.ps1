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

# Install Go
Install-PackageIfMissing -Command "go" -WingetId "GoLang.Go"

# Install Rust (Windows installer)
if (-not (Get-Command "rustc" -ErrorAction SilentlyContinue)) {
    Write-Host "Rust not found, installing via official Windows installer..."
    $rustInstaller = "$env:TEMP\rustup-init.exe"

    # Download rustup Windows installer
    Invoke-WebRequest -Uri "https://win.rustup.rs/x86_64" -OutFile $rustInstaller -UseBasicParsing

    # Run installer silently
    Start-Process -FilePath $rustInstaller -ArgumentList "-y" -Wait

    Write-Host "Rust installation complete. You may need to restart PowerShell to refresh PATH."
} else {
    Write-Host "Rust already installed: $(rustc --version)"
}

Write-Host "Stage 10 complete."
