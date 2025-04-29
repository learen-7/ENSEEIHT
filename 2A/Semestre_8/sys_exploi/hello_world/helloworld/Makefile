# name of your application
APPLICATION = "helloworld"

# Board is CC2650 Sensortag
BOARD = cc2650stk

# Comment this out to disable code in RIOT that does safety checking
# which is not needed in a production environment but helps in the
# development process:
DEVELHELP ?= 1

# Change this to 0 show compiler invocation lines by default:
QUIET ?= 1

# Add some drivers
USEMODULE += hdc1000 bmp280_i2c mpu9250 tmp007 opt3001 ztimer_sec

# Add Uniflash PATH for firmware upload 
UNIFLASH_PATH=/mnt/n7fs/ens/tp_ermont/IoT/uniflash_8.1.0

include /mnt/n7fs/ens/tp_ermont/IoT/RIOT/Makefile.include
