#!/epics/bin/merlinApp

< unique.cmd
< envPaths

errlogInit(20000)

dbLoadDatabase("$(TOP)/dbd/merlinApp.dbd")

merlinApp_registerRecordDeviceDriver(pdbbase) 


# The name of the drvAsynIPPort for commands
epicsEnvSet("COMMAND_PORT", "$(PORT)cmd")
# The name of the drvAsynIPPort for data
epicsEnvSet("DATA_PORT", "$(PORT)data")
# The IP address of the Merlin Labview system
epicsEnvSet("MERLIN_IP", "164.54.160.214")
# The IP port for the command socket
epicsEnvSet("COMMAND_IPPORT", "6341")
# The IP port for the data socket
epicsEnvSet("DATA_IPPORT",    "6342")
# The model type for this Medipix detector
epicsEnvSet("MODEL", "3")   #0=Merlin, 1=MedipixXBPM, 2=UomXBPM, 3=MerlinQuad

epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")


drvAsynIPPortConfigure($(COMMAND_PORT), $(MERLIN_IP):$(COMMAND_IPPORT), 0, 0, 0)
asynOctetSetOutputEos($(COMMAND_PORT), 0, "\n")
asynOctetSetInputEos($(COMMAND_PORT), 0, "\n")

drvAsynIPPortConfigure($(DATA_PORT), $(MERLIN_IP):$(DATA_IPPORT), 0, 0, 0)

# merlinDetectorConfig(
#              portName,           # The name of the asyn port to be created
#              LabviewCommandPort, # The name of the asyn port previously created with drvAsynIPPortConfigure to
#                                    communicate with Labview for commands.
#              LabviewDataPort,    # The name of the asyn port previously created with drvAsynIPPortConfigure to
#                                    communicate with Labview for data.
#              maxSizeX,           # The size of the merlin detector in the X direction.
#              maxSizeY,           # The size of the merlin detector in the Y direction.
#              detectorType,       # The type of detector. 0=Merlin, 1=MedipixXBPM, 2=UomXBPM, 3=MerlinQuad
#              maxBuffers,         # The maximum number of NDArray buffers that the NDArrayPool for this driver is
#                                    allowed to allocate. Set this to 0 to allow an unlimited number of buffers.
#              maxMemory,          # The maximum amount of memory that the NDArrayPool for this driver is
#                                    allowed to allocate. Set this to 0 to allow an unlimited amount of memory.
#              priority,           # The thread priority for the asyn port driver thread if ASYN_CANBLOCK is set in asynFlags.
#              stackSize,          # The stack size for the asyn port driver thread if ASYN_CANBLOCK is set in asynFlags.

# This is for a Merlin quad
merlinDetectorConfig("$(PORT)", $(COMMAND_PORT), $(DATA_PORT), $(XSIZE), $(YSIZE), $(MODEL), 0, 0, 0, 0)

asynSetTraceIOMask("$(PORT)",0,2)
#asynSetTraceMask("$(PORT)",0,255)

dbLoadRecords("$(ADMERLIN)/db/merlin.template","P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")

# Create a standard arrays plugin, set it to get data from Merlin driver.
NDStdArraysConfigure("Image1", 5, 0, "$(PORT)", 0, 0)

dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Int16,FTVL=SHORT,NELEMENTS=262144")

# Load all other plugins using commonPlugins.cmd
< $(ADCORE)/iocBoot/commonPlugins.cmd
set_requestfile_path("$(ADMERLIN)/merlinApp/Db")

#asynSetTraceMask("$(PORT)",0,255)

iocInit()

# save things every thirty seconds
create_monitor_set("auto_settings.req", 30,"P=$(PREFIX)")

