#!/epics/prod/Deb8/master/areaDetector/ADAndor3/iocs/andor3IOC/bin/linux-x86_64/andor3App
errlogInit(20000)

< /epics/prod/Deb8/master/envPaths
< unique.cmd

dbLoadDatabase("$(ADANDOR3)/iocs/andor3IOC/dbd/andor3App.dbd")
andor3App_registerRecordDeviceDriver(pdbbase) 

# andor3Config(const char *portName, int cameraId, int maxBuffers,
#              size_t maxMemory, int priority, int stackSize,
#              int maxFrames)
andor3Config("$(PORT)", "$(CAM-CONNECT)", 0, 0, 0, 0, 100)
dbLoadRecords("$(ADANDOR3)/db/andor3.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")

asynSetTraceIOMask("$(PORT)",0,2)
#asynSetTraceMask("$(PORT)",0,255)




# Create a standard arrays plugin, set it to get data from first Andor Neo driver.
NDStdArraysConfigure("Image1", 5, 0, "$(PORT)", 0, 0)

# Use (TYPE=Int8,FTVL=UCHAR), if you only want to use the Prosilica in 8-bit mode (or color mode). It uses an 8-bit waveform record
# Use (TYPE=Int16,FTVL=SHORT), if you want to use the Prosilica in 8,12 or 16-bit modes.  
# NELEMENTS is set large enough for a 1360x1024x3 image size, which is the number of pixels in RGB images from the GC1380C color camera. 
# NELEMENTS is set large enough for a 1360x1024 image size, which is the number of pixels in B/W images from the GC1380B mono camera.
# Must be at least as big as the maximum size of your camera images
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=$(NDTYPE),FTVL=$(NDFTVL),NELEMENTS=$(NELMT)")

# Load all other plugins using commonPlugins.cmd
< $(ADCORE)/iocBoot/commonPlugins.cmd
#set_requestfile_path("$(ADPROSILICA)/prosilicaApp/Db")
#set_requestfile_path("$(ADPROSILICA)/iocs/prosilicaIOC/iocBoot/iocProsilica")
set_requestfile_path("$(ADANDOR3)/andor3App/Db")
set_requestfile_path("$(ADANDOR3)/iocs/andor3IOC/iocBoot/iocAndor3")

#system("install -m 777 -d $(TOP)/as/save")
#system("install -m 777 -d $(TOP)/as/req")

#access security
#asSetFilename("/cf-update/acf/default.acf")

#asynSetTraceMask("$(PORT)",0,255)
#asynSetTraceMask("$(PORT)",0,9)
asynSetTraceIOMask("$(PORT)",0,4)

iocInit()

#must be after iocInit()
# save things every thirty seconds
create_monitor_set("auto_settings.req", 30,"P=$(PREFIX)")

# Channel Finder
dbl > ./records.dbl
#system "cp ./records.dbl /cf-update/$(HOSTNAME).$(IOCNAME).dbl"

# dbpf "$(PREFIX)cam1:GevSCPSPacketSiz", "8228"

