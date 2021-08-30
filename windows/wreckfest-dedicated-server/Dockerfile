FROM mcr.microsoft.com/windows/servercore:ltsc2019

ARG ADMIN_STEAM_USER_IDS='' \
    GAME_SERVER_NAME='' \
    PREFIX="C:\Wreckfest"

ENV WRECKFEST_HOME=$PREFIX \
    STEAM_HOME=$PREFIX\\steam \
    SERVER_HOME=$PREFIX\\server \
    LOG_FOLDER=$PREFIX\\logs \
    STARTUP_SCRIPT=$PREFIX\\startup.bat

WORKDIR $WRECKFEST_HOME

# Set the default shell to powershell...
SHELL ["powershell", "-command"]

# Copy our setupscripts into the scripts folder
COPY scripts scripts

# Allow execution of scripts on the system
# Grab Nuget, required for subsequent installs
RUN Set-ExecutionPolicy RemoteSigned -Force -Verbose; \
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Verbose

# # Now run some scripts
# SHELL ["powershell", "-file"]

# Open up the firewall
RUN scripts/Open-WreckfestPorts.ps1 -Verbose
# Set up the steamCMD environment
RUN scripts/Prepare-SteamCMD.ps1 -SteamHome $Env:STEAM_HOME -Verbose
# Set up the game server
RUN scripts/Prepare-WreckfestDedicatedServer.ps1 -ServerHome $Env:SERVER_HOME -GameServerName $Env:GAME_SERVER_NAME -GameServerLogFile $Env:LOG_FOLDER -GameServerAdminIds $Env:ADMIN_STEAM_USER_IDS -GameServerStartupScript $Env:STARTUP_SCRIPT -Verbose

SHELL ["cmd.exe", "/S", "/C" ]
ENTRYPOINT powershell
