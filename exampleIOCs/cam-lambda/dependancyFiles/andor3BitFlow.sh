# Run this script before starting the Andor Neo camera. 
# The script initializes the Camera Link interface, and installs necessary
# kernel module for Andor Neo camera.
# K. Gofron
# 2018-4-7
#
#kgofron@xf18id-srv2:~/Andor/andor/doc$ ls -l /dev/video*
#crw-rw---- 1 root video 81, 0 Apr  7 22:38 /dev/video0
#kgofron@xf18id-srv2:~/Andor/andor/doc$ sudo chmod a+rw /dev/video*
#kgofron@xf18id-srv2:~/Andor/andor/doc$ ls -l /dev/video*
#crw-rw-rw- 1 root video 81, 0 Apr  7 22:38 /dev/video0


sudo /sbin/modprobe v4l2_common
sudo /sbin/modprobe videodev
sudo /sbin/insmod /usr/local/mod/bitflow.ko fwDelay1=200 customFlags=1
sudo chmod a+rw /dev/video*
ls -l /dev/video*

