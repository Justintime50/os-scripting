# Setup Windows Subsystem for Linux
# For more info, visit: https://ubuntu.com/wsl

echo "Setting up WSL... (this will restart your machine)"

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

choco install microsoft-windows-terminal
choco install wsl-ubuntu-2004

Restart-Computer
