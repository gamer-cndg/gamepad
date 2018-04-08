#Where is our toolchain at
TOOLCHAIN_ROOT_DIR:= /home/max/source/staging_dir/target-mipsel_24kc_musl-1.1.16
#Path to our mipsel-openwrt-linux-gcc Compiler
CC:=/home/max/source/staging_dir/toolchain-mipsel_24kc_gcc-5.4.0_musl-1.1.16/bin/mipsel-openwrt-linux-gcc
# flags to include headers and libraries for the build (libncurses). 
# also include this directory for libudev.so, libevdev.so.2 and libncurses
CCFLAGS:=-L./ -I$(TOOLCHAIN_ROOT_DIR)/usr/include -L$(TOOLCHAIN_ROOT_DIR)/usr/lib

all: test

clean:
	rm -f test libgamepad.so libgamepad.so.1 gamepad.o

gamepad.o: gamepad.c gamepad.h
	$(CC) -c -fPIC -fvisibility=hidden -Wall -Werror -o $@ $< $(CCFLAGS)

libgamepad.so.1: gamepad.o gamepad.h
	$(CC) -shared -Wl,-soname,libgamepad.so.1 -o $@ $< $(CCFLAGS) -lc -lm -ludev -levdev

libgamepad.so: libgamepad.so.1
	ln -sf libgamepad.so.1 libgamepad.so

test: main.c libgamepad.so
	$(CC) -o gamepadtest $< -Wl,-rpath,. -L. -lgamepad -lncurses -ludev

install: libgamepad.so

.PHONY: all clean install
