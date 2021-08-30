<#
.Synopsis
Script to install, update, and enable steamcmd.exe on a Windows system (or in a Windows docker container).

.PARAMETER SteamHome
Path to where all steamcmd-related work should be done, and where the steamcmd should be installed.

.EXAMPLE
Prepare-SteamCMD.ps1 -SteamHome $Env:STEAM_HOME -Verbose
Use an environment variable to specify the SteamHome folder for the script to install steamcmd.exe into. Show
verbose logging output during execution.

#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string]$SteamHome
)
Write-Verbose "Operating parameters:"
Write-Verbose "==] SteamHome: '$SteamHome'"

Install-Module -Name SteamPS -Force
Import-Module SteamPS -Verbose

# Get steamcmd
Install-SteamCMD -InstallPath $SteamHome -Force

# Ensure that steamcmd.exe can get through any firewall rules to download/update apps
# but only if the firewall service is running...
if (( Get-Service -Name "Windows Defender Firewall").Status -eq "Running") {

    $SteamCmdPath=(Get-ChildItem -Path $SteamHome -Recurse -Filter steamcmd.exe)[0].FullName
    New-NetFirewallRule -Program $SteamCmdPath
                        -Action Allow
                        -Profile Domain, Public, Private
                        -DisplayName "SteamCMD.exe"
                        -Description "Allow SteamCMD through the firewall"
                        -Direction Outbound
                        -Enabled True
}
