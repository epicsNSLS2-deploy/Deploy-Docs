#!/epics/bin/spinnakerApp

< unqiue.cmd
< envPaths
errlogInit(20000)

dbLoadDatabase("$(TOP)/dbd/spinnakerApp.dbd")
spinnakerApp_registerRecordDeviceDriver(pdbbase) 


# Define NELEMENTS to be enough for a 2048x2048x3 (color) image
epicsEnvSet("NELEMENTS", "12592912")
epicsEnvSet("CAMERA_ID", 0)
# Add spinnaker db to include path
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(EPICS_DB_INCLUDE_PATH);$(ADSPINNAKER)/db")

# ADSpinnakerConfig(const char *portName, const char *cameraId, int traceMask, int memoryChannel,
#                 int maxBuffers, size_t maxMemory, int priority, int stackSize)
ADSpinnakerConfig("$(PORT)", $(CAM-CONNECT), 0x1, 0)

asynSetTraceIOMask($(PORT), 0, 2)
# Set ASYN_TRACE_WARNING and ASYN_TRACE_ERROR
#asynSetTraceMask($(PORT), 0, 0x21)
#asynSetTraceFile($(PORT), 0, "asynTrace.out")
#asynSetTraceInfoMask($(PORT), 0, 0xf)

# Main database.  This just loads and modifies ADBase.template
dbLoadRecords("$(ADSPINNAKER)/db/spinnaker.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT)")

# Video mode
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerMenuProp.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=VideoMode,PN=SP_VIDEO_MODE")

# Frame rate
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerFloatProp.template",   "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=FrameRate,PN=SP_FRAME_RATE,VAL=10.,READBACK=1")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerPropAuto.template",    "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=FrameRate,PN=SP_FRAME_RATE")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerPropEnable.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=FrameRate,PN=SP_FRAME_RATE")

# Acquire time
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerPropAuto.template",     "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=AcquireTime,PN=ACQ_TIME")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerFloatMinMax.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=AcquireTime,PN=ACQ_TIME")

# Gain
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerPropAuto.template",     "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=Gain,PN=GAIN")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerFloatMinMax.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=Gain,PN=GAIN")

# Black level
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerFloatProp.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=BlackLevel,PN=SP_BLACK_LEVEL,VAL=0.0")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerPropAuto.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=BlackLevel,PN=SP_BLACK_LEVEL")

# Black level balance.  No value, only auto
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerPropAuto.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=BlackLevelBalance,PN=SP_BLACK_LEVEL_BALANCE")

# White balance controls
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerFloatProp.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=WhiteBalanceRatio,    PN=SP_WHITE_BALANCE_RATIO,VAL=0.0")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerMenuProp.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=WhiteBalanceSelector, PN=SP_WHITE_BALANCE_SELECTOR")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerPropAuto.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=WhiteBalance,         PN=SP_WHITE_BALANCE")

# Saturation
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerFloatProp.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=Saturation,PN=SP_SATURATION,VAL=0.1")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerPropEnable.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=Saturation,PN=SP_SATURATION")

# Gamma
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerFloatProp.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=Gamma,PN=SP_GAMMA,VAL=1.0")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerPropEnable.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=Gamma,PN=SP_GAMMA")

# Sharpening
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerFloatProp.template",   "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=Sharpening,PN=SP_SHARPENING")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerPropAuto.template",    "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=Sharpening,PN=SP_SHARPENING")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerPropEnable.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=Sharpening,PN=SP_SHARPENING")

# Pixel format
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerMenuProp.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=PixelFormat,PN=SP_PIXEL_FORMAT")

# Convert pixel format.  This has a non-generic template file because we constrain the menu choices.
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerConvertPixelFormat.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=ConvertPixelFormat,PN=SP_CONVERT_PIXEL_FORMAT")

# Trigger source
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerMenuProp.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=TriggerSource,PN=SP_TRIGGER_SOURCE")

# Trigger activation
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerMenuProp.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=TriggerActivation,PN=SP_TRIGGER_ACTIVATION")

# Trigger delay
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerFloatProp.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=TriggerDelay,PN=SP_TRIGGER_DELAY,VAL=0.01")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerPropEnable.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=TriggerDelay,PN=SP_TRIGGER_DELAY")

# Trigger overlap
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerMenuProp.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=TriggerOverlap,PN=SP_TRIGGER_OVERLAP")

# Exposure mode
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerMenuProp.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=ExposureMode,PN=SP_EXPOSURE_MODE")

# Software trigger
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerCmdProp.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=SoftwareTrigger,PN=SP_SOFTWARE_TRIGGER")

# Transport diagnostics
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerIntReadback.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=TransmitFailureCount,PN=SP_TRANSMIT_FAILURE_COUNT")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerIntReadback.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=BufferUnderrunCount, PN=SP_BUFFER_UNDERRUN_COUNT")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerIntReadback.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=FailedBufferCount,   PN=SP_FAILED_BUFFER_COUNT")
dbLoadRecords("$(ADSPINNAKER)/db/spinnakerIntReadback.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),PROP=FailedPacketCount,   PN=SP_FAILED_PACKET_COUNT")

# Create a standard arrays plugin
NDStdArraysConfigure("Image1", 5, 0, "$(PORT)", 0, 0)
# Use this line for 8-bit data only
#dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Int8,FTVL=CHAR,NELEMENTS=$(NELEMENTS)")
# Use this line for 8-bit or 16-bit data
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Int16,FTVL=SHORT,NELEMENTS=$(NELEMENTS)")

# Load all other plugins using commonPlugins.cmd
< $(ADCORE)/iocBoot/commonPlugins.cmd
set_requestfile_path("$(ADSPINNAKER)/spinnakerApp/Db")

iocInit()

# save things every thirty seconds
create_monitor_set("auto_settings.req", 30,"P=$(PREFIX)")

# Wait for enum callbacks to complete
epicsThreadSleep(1.0)

# Wait for callbacks on the property limits (DRVL, DRVH) to complete
epicsThreadSleep(1.0)


