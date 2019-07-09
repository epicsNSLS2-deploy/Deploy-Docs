:: Batch file for cleaning up the IOC directory.

@echo off
cd /D "%~dp0"

rmdir /s /q dependancyFiles\
rmdir /s /q startupScripts\
rmdir /s /q autosaveFiles\
rmdir /s /q logs\
rmdir /s /q .git\

mkdir autosave
del README*
del .gitignore
del *OLD*
del cleanup.sh
del cleanup.bat
