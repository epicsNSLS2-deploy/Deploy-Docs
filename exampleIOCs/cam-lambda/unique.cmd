# ########################################
# File containing Unique IOC parameters  #
# Author: K. Gofron                      #
# ########################################


# Set this to the folder for support.
# Two supported formats: 
# base and support in one directory (must edit envPaths)
# base inside support
epicsEnvSet("SUPPORT_DIR", "/epics/Deb8")

# Maintainer
epicsEnvSet("ENGINEER",                 "K. Gofron X5283")

# IOC Information
epicsEnvSet("PORT",                     "LAMBDA1")
epicsEnvSet("IOC",                      "iocADUVC")

epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST",  "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST",       "10.10.0.255")
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "6000000")

# Identify which connection camera IOC uses
epicsEnvSet("CAM-CONNECT",                   "25344")
#epicsEnvSet("CAM-CONNECT",                   "10.10.1.91")
#epicsEnvSet("CAM-CONNECT",	"/opt/xsp/config")


# PV and IOC Name configs
epicsEnvSet("PREFIX",                   "XF:10IDC-BI{Lambda-Cam:1}")
epicsEnvSet("CTPREFIX",                 "XF:10IDC-BI{Lambda-Cam:1}")
epicsEnvSet("HOSTNAME",                 "xf10idd-ioc3")
epicsEnvSet("IOCNAME",                  "cam-lambda")

# Image and data size
epicsEnvSet("QSIZE",                    "30")
epicsEnvSet("NCHANS",                   "2048")
epicsEnvSet("HIST_SIZE",                "4096")
epicsEnvSet("XSIZE",                    "1024")
epicsEnvSet("YSIZE",                    "1024")
epicsEnvSet("NELMT",                    "65536")
epicsEnvSet("NDTYPE",                   "Int16")  #'Int8' (8bit B/W, Color) | 'Int16' (16bit B/W)
epicsEnvSet("NDFTVL",                   "SHORT") #'UCHAR' (8bit B/W, Color) | 'SHORT' (16bit B/W)
epicsEnvSet("CBUFFS",                   "500")

# The framerate at which the stream will operate (used by UVC camera)
epicsEnvSet("FRAMERATE",                "30");
