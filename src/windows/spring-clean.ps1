# Spring Clean Windows
# NOTE: Must be run in PowerShell, not command line (win + x -> Windows Powershell (Admin))

echo "Spring cleaning Windows..."

# Open apps used to spring clean and scan for viruses
Start-Process -FilePath "C:\Program Files\CCleaner\CCleaner.exe"
Start-Process -FilePath "C:\Program Files\Malwarebytes\Anti-Malware\mbam.exe"
Start-Process -FilePath "C:\Program Files\Windows Defender\MpCmdRun.exe"

# Update Windows
# Set-PSRepository "PSGallery" -InstallationPolicy Trusted
# Install-Module PSWindowsUpdate
Get-WindowsUpdate
Install-WindowsUpdate -AcceptAll

echo "Script complete!"
