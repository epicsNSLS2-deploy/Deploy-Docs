#!/epics/prod/Deb7/R3-4/areaDetector/ADUVC/iocs/adUVCIOC/bin/linux-x86_64/adUVCApp

< unique.cmd
errlogInit(20000)

< envPaths

#epicsThreadSleep(20)
dbLoadDatabase("$(ADUVC)/iocs/adUVCIOC/dbd/adUVCApp.dbd")
adUVCApp_registerRecordDeviceDriver(pdbbase) 

#/*
# * Constructor for ADUVC driver. Most params are passed to the parent ADDriver constructor. 
# * Connects to the camera, then gets device information, and is ready to aquire images.
# * 
# * @params: portName -> port for NDArray recieved from camera
# * @params: serial -> serial number of device to connect to
# * @params: productID -> id number for device to connect to
# * @params: framerate -> framerate at which camera should operate
# * @params: xsize -> width of image
# * @params: ysize -> height of image
# * @params: maxBuffers -> max buffer size for NDArrays
# * @params: maxMemory -> maximum memory allocated for driver
# * @params: priority -> what thread priority this driver will execute with
# * @params: stackSize -> size of the driver on the stack
# */

# If searching for device by serial number, put 0 and 0 for vendor/productID
# ADUVCConfig(const char* portName, const char* serial, int vendorID, int productID, int framerate, int xsize, int ysize, int maxBuffers, size_t maxMemory, int priority, int stackSize)
# Uncomment this line if using serial number to connect
#ADUVCConfig("$(PORT)", "$(CAM-CONNECT", 0, "$(FRAMERATE)", "$(XSIZE)", "$(YSIZE)", 0, 0, 0, 0)
# Uncomment this line if using product ID to connect
ADUVCConfig("$(PORT)", "", $(CAM-CONNECT), $(FRAMERATE), $(XSIZE), $(YSIZE), 0, 0, 0, 0)
epicsThreadSleep(2)

asynSetTraceIOMask($(PORT), 0, 2)
#asynSetTraceMask($(PORT),0,0xff)

# Load the templates for camera PVs
dbLoadRecords("$(ADCORE)/db/ADBase.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADUVC)/db/ADUVC.template","P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")


#
# Create a standard arrays plugin, set it to get data from Driver.
#int NDStdArraysConfigure(const char *portName, int queueSize, int blockingCallbacks, const char *NDArrayPort, int NDArrayAddr, int maxBuffers, size_t maxMemory,
#                          int priority, int stackSize, int maxThreads)
NDStdArraysConfigure("Image1", 3, 0, "$(PORT)", 0)
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,NDARRAY_PORT=$(PORT),TIMEOUT=1,TYPE=Int16,FTVL=SHORT,NELEMENTS=20000000")


# Load all other plugins using commonPlugins.cmd
< $(ADCORE)/iocBoot/commonPlugins.cmd

set_requestfile_path("$(ADUVC)/adUVCApp/Db")

# debug sets
#asynSetTraceMask($(PORT),0,0x09)
#asynSetTraceMask($(PORT),0,0x11)

iocInit()

# save things every thirty seconds
create_monitor_set("auto_settings.req", 30, "P=$(PREFIX)")
