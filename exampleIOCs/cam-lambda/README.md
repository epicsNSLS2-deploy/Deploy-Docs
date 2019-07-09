# ioc-template

A template used for installing areaDetector IOCs with NSLS2 prebuilt bundles.

### Included components

Component   |       Description
------------|---------------------------
startupScripts | Directory containing IOC st.cmd startup scripts for each device configured for use with the IOC template
dependencyScripts | Some devices need additional scripts run pre-iocInit (ex. Andor3 detector). They are housed here
unique.cmd | File containting all IOC specific environement variables
envPaths | File contatining relative paths to all EPICS components. DO NOT EDIT, all components relative to unique.cmd
config | Basic config file for use with procServer and soft-ioc
logs | directory contatining IOC startup issues and log dumps
.hgignore | ignore file for use with mercurial version control
cleanup.sh | script used to remove all unused portions of ioc-template once it is deployed

### Usage - initIOC

The recommended usage for this repository is with [initIOC](https://github.com/epicsNSLS2-deploy/initIOC). `initIOC` is a configurable script that will auto-initialize any number of detector IOCs that are supported by `ioc-template`.

For `initIOC` usage instructions, please check the above linked repositry.

### Usage - manual

To use the ioc-template, start by cloning this repository, or downloading a release.

Then perform the following steps in order:
* Remove the st.cmd file and copy one from the `startupScripts` directory that is appropriate for the IOC in use.
* Check to make sure that the startup script is pointing to the correct binary location. This will be in the first line of the startup script.
* Edit the `unique.cmd` file, editing all relevant environment variables to match with your IOC. Note that CAM-CONNECT is the variable used to connect to the camera, and can be a serial number, IP etc.
* If using mercurial, initialize the hg repository, add, commit, and push the contents to a remote
* Start the IOC by running `./st.cmd`, or if required, first run the dependency script.

