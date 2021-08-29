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
# Grab Nuget, required for subsequent installs
RUN Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Verbose

# Copy our setupscripts into the scripts folder
COPY scripts scripts

# Now run some scripts
SHELL ["powershell", "-file"]

# Open up the firewall
RUN scripts/Open-WreckfestPorts.ps1 -Verbose

# Set up the steamCMD environment
RUN scripts/Prepare-SteamCMD.ps1 -SteamHome ${STEAM_HOME} -Verbose

# Set up the game server
RUN scripts/Prepare-WreckfestDedicatedServer.ps1 -ServerHome ${SERVER_HOME} -GameServerName ${GAME_SERVER_NAME} -GameServerLogFile ${LOG_FOLDER} -GameServerAdminIds ${ADMIN_STEAM_USER_IDS} -GameServerStartupScript ${STARTUP_SCRIPT} -Verbose

SHELL ["cmd.exe", "/S", "/C" ]
ENTRYPOINT powershell

# ENTRYPOINT ${STARTUP_SCRIPT}

# Step 13/17 : RUN scripts/Open-WreckfestPorts.ps1 -Verbose
#  ---> Running in e4f4effd9ac7
# New-NetFirewallRule : There are no more endpoints available from the endpoint 
# mapper.
# At C:\Wreckfest\scripts\Open-WreckfestPorts.ps1:12 char:9
# +         New-NetFirewallRule -DisplayName "Wreckfest Dedicated Server  ...
# +         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : NotSpecified: (MSFT_NetFirewallRule:root/standar
#    dcimv2/MSFT_NetFirewallRule) [New-NetFirewallRule], CimException
#     + FullyQualifiedErrorId : Windows System Error 1753,New-NetFirewallRule

# New-NetFirewallRule : There are no more endpoints available from the endpoint 
# mapper.
# At C:\Wreckfest\scripts\Open-WreckfestPorts.ps1:12 char:9
# +         New-NetFirewallRule -DisplayName "Wreckfest Dedicated Server  ...
# +         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : NotSpecified: (MSFT_NetFirewallRule:root/standar
#    dcimv2/MSFT_NetFirewallRule) [New-NetFirewallRule], CimException
#     + FullyQualifiedErrorId : Windows System Error 1753,New-NetFirewallRule

# New-NetFirewallRule : There are no more endpoints available from the endpoint 
# mapper.
# At C:\Wreckfest\scripts\Open-WreckfestPorts.ps1:12 char:9
# +         New-NetFirewallRule -DisplayName "Wreckfest Dedicated Server  ...
# +         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : NotSpecified: (MSFT_NetFirewallRule:root/standar
#    dcimv2/MSFT_NetFirewallRule) [New-NetFirewallRule], CimException
#     + FullyQualifiedErrorId : Windows System Error 1753,New-NetFirewallRule
