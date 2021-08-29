<#
.Synopsis
Script to install and setup Wreckfest Dedicated Server on a Windows system (or in a Windows docker container) that has the SteamPS module installed.

.Description
Using the SteamPS (https://github.com/hjorslev/SteamPS) Powershell module, download the wreckfest installer. Then update the server configuration
settings for the game server according to the parameters sent into this script. Finally, create a script that will start the server at any point
in the future by parsing and updating the default start_server.bat script that is shipped with the dedicated server.

.PARAMETER ServerHome
Path to where all game server work (downloads, parsing, etc...) should be done, and where the executables should be installed under.

.PARAMETER SteamAppId
Optional steam app id of the game server itself (will be deduced at runtime if omitted/set to the empty string).

.PARAMETER GameConfigTemplate
Optional game server configuration file template (default initial configuration will be used if omitted).

.PARAMETER GameServerName
Optional game server name (if not given will be set to an amalgum of machine-name and 'wreckfest').

.PARAMETER GameServerLogFile
Optional logfile parameter for the server (if not given will be left at '' and removed/disabled in the config).

.PARAMETER GameServerAdminIds
Optional comma-separated list of Steam User Ids. This list defines the people who are allowed to adminster the server (via the game client). Default is 'first one in'.

.PARAMETER GameServerStartupScript
Path to the simple startup script that we create for the game. If omitted the script will be named game-server-startup.bat in the ServerHome folder.

.EXAMPLE
Prepare-WreckfestDedicatedServer.ps1 -ServerHome C:\Wreckfest\service -Verbose
Install and set up the dedicated server under the C:\Wreckfest\service path, and show
verbose logging output during execution.

#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true,
               Position=0,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Install path for game server.")]
    [ValidateNotNullOrEmpty()]
    [string]$ServerHome,

    [Parameter(Mandatory=$false,
               Position=1,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Steam appid of game server")]
    [string]$SteamAppId='361580',

    [Parameter(Mandatory=$false,
               Position=2,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Game server configuration template")]
    [string]$GameConfigTemplate='',

    [Parameter(Mandatory=$false,
               HelpMessage="Game server name")]
    [string]$GameServerName='',

    [Parameter(Mandatory=$false,
               HelpMessage="Log file path")]
    [string]$GameServerLogFile='',

    [Parameter(Mandatory=$false,
               HelpMessage="Steam user ids (comma-separated list) to specify game server admins")]
    [string]$GameServerAdminIds='',

    [Parameter(Mandatory=$false,
               HelpMessage="Startup script path")]
    [string]$GameServerStartupScript=''
)

# "Constants" insofar as Powershell can have constants
$SteamAppShortName = "Wreckfest"
$SteamAppName = "Wreckfest Dedicated Server"
$SteamAppDefaultConfigFilename = "initial_server_config.cfg"
$DefaultStartupScriptFilename="game-server-startup.bat"

Write-Verbose "Operating parameters:"
Write-Verbose "==] ServerHome: '$ServerHome'"
Write-Verbose "==] SteamAppId: '$SteamAppId'"
Write-Verbose "==] GameConfigTemplate: '$GameConfigTemplate'"
Write-Verbose "==] GameServerName: '$GameServerName'"
Write-Verbose "==] GameServerLogFile: '$GameServerLogFile'"
Write-Verbose "==] GameServerAdminIds: '$GameServerAdminIds'"
Write-Verbose "==] GameServerStartupScript: '$GameServerStartupScript'"
Write-Verbose "==] SteamAppShortName: '$SteamAppShortName'"
Write-Verbose "==] SteamAppName: '$SteamAppName'"
Write-Verbose "==] SteamAppDefaultConfigFilename: '$SteamAppDefaultConfigFilename'"
Write-Verbose "==] DefaultStartupScriptFilename: '$DefaultStartupScriptFilename'"

Write-Verbose "STEP 1: Get our trusty steamPS module up and running"
Import-Module SteamPS

Write-Verbose "STEP 2: Get the appid for Wreckfest server (this will likely never change from 361580 so call this overkill if you wish)"
if ($SteamAppId -eq '') {
    Write-Verbose "SteamAppId was not specified, obtaining it from steamcmd..."
    $steamid = Find-SteamAppID -ApplicationName $SteamAppName
    Write-Verbose "SteamAppId obtained: $($steamid.appid)"
    $SteamAppId = $steamid.appid
}

Write-Verbose "STEP 3: 'Update' or install-if-not-there the dedicated server."
Write-Verbose "Installing/updated the $SteamAppName app in folder $($ServerHome)"
Update-SteamApp -AppId $SteamAppId -Path $ServerHome -Force

Write-Verbose "STEP 4: Update the base settings for the server with passed in values as necessary"
Write-Verbose "find the initial_server_config.cfg that ships with the game server"
if ($GameConfigTemplate -eq '') {
    Write-Verbose "GameConfigTemplate was not specified, obtaining $SteamAppDefaultConfigFilename from the app..."
    $GameConfigTemplate=(Get-ChildItem -Path $ServerHome -Recurse -Filter $SteamAppDefaultConfigFilename)[0].FullName
}
Write-Verbose "Using configuration template file to create config: $GameConfigTemplate"
$ServerConfig = Join-Path -Path $ServerHome -ChildPath "server_config.cfg"
Write-Verbose "Writing configuration file to use here: $ServerConfig"

Write-Verbose "STEP 5: Ensure a valid game server name"
if ($GameServerName -eq '') {
    $GameServerName = "$ENV:COMPUTERNAME_$SteamAppShortName"
    Write-Verbose "No game server name was specified, created from this machine name + game service name: $GameServerName"
}
Write-Verbose "Using game server name = $GameServerName"


Write-Verbose "STEP 6: Modify the server configuration with values sent in"
(Get-Content -Path $GameConfigTemplate) | Foreach-Object {
    # Set the game server name
    if ($PSItem -match "^server_name=.*$") {
        Write-Verbose "==] Found the server_name line '$PSItem'"
        Write-Verbose "==] Changing it to 'server_name=$GameServerName'"
    }
    $PSItem -replace "^server_name=.*$", "server_name=$GameServerName"
    # Set the logfile
    if ($PSItem -match "^log=.*$") {
        Write-Verbose "==] Found the log line '$PSItem'"
        Write-Verbose "==] Changing it to 'log=$GameServerLogFile'"
    }
    $PSItem -replace "^log=.*$", "log=$GameServerLogFile"
    # Set any admins
    if ($GameServerAdminIds -ne '') {
        # do not set the first connected user to the admin, we have a list of admins
        if ($PSItem -match "^owner_disabled=.*$") {
            Write-Verbose "==] Found the log line '$PSItem'"
            Write-Verbose "==] Changing it to 'owner_disabled=1'"
        }
        $PSItem -replace "^owner_disabled=.*$", "owner_disabled=1"
        # set the list of admins (note that this is commented out in the default game server config)
        if ($PSItem -match "^[#]*admin_steam_ids=.*$") {
            Write-Verbose "==] Found the log line '$PSItem'"
            Write-Verbose "==] Changing it to 'admin_steam_ids=$GameServerAdminIds'"
        }
        $PSItem -replace "^[#]*admin_steam_ids=.*$", "admin_steam_ids=$GameServerAdminIds"
    }
} | Set-Content -Path $ServerConfig -Encoding oem

# create a simple startup script
if ($GameServerStartupScript -eq '') {
    $GameServerStartupScript = Join-Path -Path $ServerHome -ChildPath $DefaultStartupScriptFilename
}
