# Windows Setup Script
# NOTE: Must be run in PowerShell, not command line (win + x -> Windows Powershell (Admin))

echo "Setting up Windows..."

# Install Choco package manager
echo "Installing Choco..."
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install packages
echo "Installing packages..."
choco install googlechrome -y
choco install malwarebytes -y
choco install ccleaner -y

# Update Windows
Set-PSRepository "PSGallery" -InstallationPolicy Trusted
Install-Module PSWindowsUpdate
Get-WindowsUpdate
Install-WindowsUpdate -AcceptAll

echo "Windows setup!"
