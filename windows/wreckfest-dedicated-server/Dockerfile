FROM mcr.microsoft.com/windows/servercore:ltsc2019

ARG ADMIN_STEAM_USER_IDS=''
ARG GAME_SERVER_NAME=''
ARG PREFIX="C:\Wreckfest"

ENV WRECKFEST_HOME=${PREFIX}
ENV STEAM_HOME=${WRECKFEST_HOME}\steam
ENV SERVER_HOME=${WRECKFEST_HOME}\server
ENV LOG_FOLDER=${WRECKFEST_HOME}\logs
ENV STARTUP_SCRIPT=${SERVER_HOME}\startup.bat

WORKDIR ${WRECKFEST_HOME}

# Set the default shell to powershell...
SHELL ["powershell", "-command"]

# Allow execution of scripts on the system
RUN Set-ExecutionPolicy RemoteSigned -Force -Verbose
# Set up trusted install-from repository
RUN Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Verbose
# Grab Nuget, required for subsequent installs
RUN Install-Module -Name Nuget -Verbose
# Install SteamPS, used by our install scripts later
RUN Install-Module -Name SteamPS -Verbose

# Copy our setupscripts into the scripts folder
COPY scripts scripts

# Open up the firewall
RUN [ "scripts/Open-WreckfestPorts.ps1", "-Verbose" ]

# Set up the steamCMD environment
RUN [ "scripts/Prepare-SteamCMD.ps1", "-SteamHome ${STEAM_HOME}", "-Verbose" ]

# Set up the game server
RUN [ "scripts/Prepare-WreckfestDedicatedServer.ps1", "-ServerHome", ${SERVER_HOME}, "-GameServerName", ${GAME_SERVER_NAME}, "-GameServerLogFile", ${LOG_FOLDER}, "-GameServerAdminIds", ${ADMIN_STEAM_USER_IDS}, "-GameServerStartupScript", "${STARTUP_SCRIPT}", "-Verbose" ]

SHELL ["cmd.exe", "/S", "/C" ]
ENTRYPOINT [ ${STARTUP_SCRIPT} ]
