# Wreckfest dedicated server on Windows

Run a wreckfest dedicated server using Windows-based Docker containers instead of Linux + Wine.

## Source material

Pulled a bunch of data from the web to discover how to host your own dedicated server for Wreckfest, here's some of them (and thanks!):

- [On Steam's forums a Bugbear dev wrote this great description.](https://steamcommunity.com/app/228380/discussions/0/613938693082657261/)
- [Bugbear's forums has this great rundown.](http://community.bugbeargames.com/threads/multiplayer-dedicated-server-easy-step-by-step-w-pictures-2019.12013/)
- [@TheLysdexicOne on Github](https://github.com/TheLysdexicOne/wreckfest-server). Copied some of their content from my top choice I think but included a Python script I read through.

## Setup on host

- Install docker desktop for Windows
- Configure docker desktop for Windows to host Windows containers
- Open game ports using Windows Defender Firewall with Advanced Security
- Download steamcmd.exe & helpers
- Download the game server and configure it
- Create a simple 'startup' script to start the server

## TODO

- It all works now, the things are all installed and seem to be in the right state.
- However, the server never runs, it silently exits with no logs, no nothing.
- Trying to use SteamCDM.exe from within the 'trial' (v0.0.3) container I made, without specifying the installation folder (perhaps they assumed steam stuff would be close by?)
- Note that specifying ports upon running the container is a bit odd: see command history for my long drawn out set (should update the firewall rules script too)
- Improve build time by pre-downloading the SteamCmd and the update for wreckfest server, then COPY-ing it to the container.

> install direct_x with "/T:$Env:ServerHome /C /Q" and that should work, see the installer downloaded on my host for details.
> ensure d3d*.dll and x*.dll files end up in the wreckfest exe directory
> read release notes to see if I am missing anything