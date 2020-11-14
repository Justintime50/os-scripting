# Update Windows
# NOTE: Must be run in PowerShell, not command line (win + x -> Windows Powershell (Admin))

echo "Updating Windows..."

# Update Windows
# Set-PSRepository "PSGallery" -InstallationPolicy Trusted
# Install-Module PSWindowsUpdate
Get-WindowsUpdate
Install-WindowsUpdate -AcceptAll

echo "Windows updated!"
