#!/epics/bin/pilatusApp


< unique.cmd
< envPaths

errlogInit(20000)

dbLoadDatabase("$(TOP)/dbd/pilatusDetectorApp.dbd")
pilatusDetectorApp_registerRecordDeviceDriver(pdbbase) 


###
# Create the asyn port to talk to the Pilatus on port 41234.
#drvAsynIPPortConfigure("camserver","gse-pilatus1:41234")
# Use the AsynIPPort to connect to the camera
drvAsynIPPortConfigure("camserver","$(CAM-CONNECT)")

# Uncomment the following to enable asynTrace on the camserver port
#asynSetTraceIOMask("camserver",0,2)
#asynSetTraceMask("camserver",0,9)
# Set the input and output terminators.

asynOctetSetInputEos("camserver", 0, "\030")
asynOctetSetOutputEos("camserver", 0, "\n")

pilatusDetectorConfig("$(PORT)", "camserver", $(XSIZE), $(YSIZE), 0, 0)
dbLoadRecords("$(ADPILATUS)/db/pilatus.template","P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1,CAMSERVER_PORT=camserver")

# Create a standard arrays plugin
NDStdArraysConfigure("Image1", 5, 0, "$(PORT)", 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Int32,FTVL=LONG,NELEMENTS=94965")

# Load all other plugins using commonPlugins.cmd
< $(ADCORE)/iocBoot/commonPlugins.cmd
set_requestfile_path("$(ADPILATUS)/pilatusApp/Db")

# Uncomment to enable asynTrace on the driver port
#asynSetTraceMask("$(PORT)",0,255)


iocInit()

# save things every thirty seconds
create_monitor_set("auto_settings.req", 30,"P=$(PREFIX)")
