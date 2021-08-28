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
