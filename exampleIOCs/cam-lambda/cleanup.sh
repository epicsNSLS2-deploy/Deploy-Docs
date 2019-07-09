#!/bin/bash

#
# Script that cleans up IOC directory after ioc-template has been cloned
#
# Author: Jakub Wlodek
#

# Make sure we are in the correct dir
cd "${0%/*}"

# Remove erroneous files/dirs
rm -rf dependancyFiles/
rm -rf startupScripts/
rm -rf autosaveFiles/
rm -rf logs/
rm README.md
mkdir autosave
rm *OLD*
rm cleanup.bat
rm cleanup.sh
