CONTIKI_PROJECT = hello_world

BOARD=sensortag/cc2650
PORT=/dev/ttyACM0

TARGET = cc26x0-cc13x0
MODULES_REL += $(TARGET)

PLATFORMS_ONLY = cc26x0-cc13x0

all: $(CONTIKI_PROJECT)

CONTIKI = /mnt/n7fs/ens/tp_ermont/IoT/contiki-ng
include $(CONTIKI)/Makefile.include
