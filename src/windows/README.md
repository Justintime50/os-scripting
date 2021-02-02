<div align="center">

# Windows Scripts

A collection of Windows scripts that can be used to automate deploying and administrating Windows devices.

<img src="../../assets/windows.png">

</div>

## Usage

All scripts ending in `.ps1` are Powershell scripts, **not** command line scripts (batch files). Acccess Powershell by clicking `win + x` keys then select `Windows Powershell (Admin)`. Otherwise, you can use the `.bat` files in this project on the command line.

```powershell
# Allow any downloadable scripts to be executed
Set-ExecutionPolicy Unrestricted
```

### Setup Windows

Setup Windows by installing the `Choco` package manager which installs `Chrome`, `CCleaner`, and `Malwarebytes`. Finish by updating Windows.

```powershell
# From Powershell
& "C:\path\to\windows-setup.ps1"
```

### Spring Clean Windows

Spring clean Windows by running `Windows Defender` from the command line, and opening `CCleaner`, and `Malwarebytes`. Finish by updating Windows.

```powershell
# From Powershell
& "C:\path\to\spring-clean.ps1"
```

### Update Windows

Update Windows from the command line.

```powershell
# From Powershell
& "C:\path\to\update-windows.ps1"
```
