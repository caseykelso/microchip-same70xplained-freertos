BASE.DIR=$(PWD)
DOWNLOADS.DIR=$(BASE.DIR)/downloads
INSTALLED.HOST.DIR=$(BASE.DIR)/installed.host
INSTALLED.TARGET.DIR=$(BASE.DIR)/installed.target
TOOLCHAIN.ARCHIVE.LINUX=$(DOWNLOADS.DIR)/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2
TOOLCHAIN.ARCHIVE.OSX=$(DOWNLOADS.DIR)/gcc-arm-none-eabi-7-2017-q4-major-mac.tar.bz2
TOOLCHAIN.DIR=$(BASE.DIR)/gcc-arm-none-eabi-7-2017-q4-major
TOOLCHAIN.URL.LINUX=https://s3.amazonaws.com/buildroot-sources/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2
TOOLCHAIN.URL.OSX=https://s3.amazonaws.com/buildroot-sources/gcc-arm-none-eabi-7-2017-q4-major-mac.tar.bz2
CMAKE.URL=https://s3.amazonaws.com/buildroot-sources/cmake-3.10.2.tar.gz
CMAKE.DIR=$(DOWNLOADS.DIR)/cmake-3.10.2
CMAKE.ARCHIVE=$(DOWNLOADS.DIR)/cmake-3.10.2.tar.gz
CMAKE.BIN=$(INSTALLED.HOST.DIR)/bin/cmake
FIRMWARE.DIR=$(BASE.DIR)/firmware
FIRMWARE.BUILD=$(BASE.DIR)/build.firmware
STRIP.BIN=$(TOOLCHAIN.DIR)/bin/arm-none-eabi-strip
FIRMWARE.BIN=$(FIRMWARE.BUILD)/firmware.elf
FREERTOS.ARCHIVE=freertos-trunk-r2536.tar.gz
FREERTOS.URL=https://s3.amazonaws.com/buildroot-sources/$(FREERTOS.ARCHIVE)
FREERTOS.DIR=$(DOWNLOADS.DIR)/freertos-trunk-r2536
OPENOCD.ARCHIVE=openocd-10.0-7b94ae9e.tar.gz
OPENOCD.URL=https://s3.amazonaws.com/buildroot-sources/$(OPENOCD.ARCHIVE)
OPENOCD.DIR=$(DOWNLOADS.DIR)/openocd
OPENOCD.BIN=$(INSTALLED.HOST.DIR)/bin/openocd
OPENOCD.CONFIG.SAM70=$(INSTALLED.HOST.DIR)/share/openocd/scripts/target/at91sam7x512.cfg
OPENOCD.CONFIG.FLASH=$(BASE.DIR)/flash.cfg
OPENOCD.CONFIG.GDB=$(BASE.DIR)/gdb.cfg
ASF.DIR=$(FIRMWARE.DIR)/src/ASF
CONFIG.DIR=$(FIRMWARE.DIR)/src/config
HIDAPI.URL=https://s3.amazonaws.com/buildroot-sources/hidapi-0.8.0-rc1.tar.gz
HIDAPI.DIR=$(DOWNLOADS.DIR)/hidapi-0.8.0-rc1
HIDAPI.ARCHIVE=hidapi-0.8.0-rc1.tar.gz
GENROMFS.URL=http://downloads.sourceforge.net/romfs/genromfs-0.5.2.tar.gz
GENROMFS.DIR=$(DOWNLOADS.DIR)/genromfs-0.5.2
GENROMFS.ARCHIVE=genromfs-0.5.2.tar.gz

OS := $(shell uname)




firmware.release: firmware.clean
	mkdir $(FIRMWARE.BUILD)
	cd $(FIRMWARE.BUILD) &&  export PATH=$(PATH):$(INSTALLED.HOST.DIR)/bin  export ARMGCC_DIR=$(TOOLCHAIN.DIR) && $(CMAKE.BIN) -DCMAKE_PROGRAM_PATH=$(INSTALLED.HOST.DIR)/bin -DCMAKE_MAKE_PROGRAM=/usr/bin/make -DWITH_BIG_ENDIAN=ON -DFREERTOS.DIR=$(FREERTOS.DIR) -DSOURCE_PATH=$(FIRMWARE.DIR) -DASF.DIR=$(ASF.DIR) -DCONFIG.DIR=$(CONFIG.DIR) -DLIBS_PATH=$(FIRMWARE.DIR)/libs -DUTILS.DIR=$(FIRMWARE.DIR)/utils -DTOOLCHAIN_DIR=$(TOOLCHAIN.DIR) -DCMAKE_LIBRARY_PATH=$(TOOLCHAIN.DIR)/arm-none-eabi/libc/usr/lib/thumb -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=$(BASE.DIR)/cortexm7.cmake -DCMAKE_PROGRAM_PATH=$(TOOLCHAIN.DIR)/bin -DCMAKE_CXX_COMPILER=$(TOOLCHAIN.DIR)/bin/arm-none-eabi-g++ -DCMAKE_C_COMPILER=$(TOOLCHAIN.DIR)/bin/arm-none-eabi-gcc $(FIRMWARE.DIR) && make -j4 
	$(STRIP.BIN)  $(FIRMWARE.BIN)


firmware.debug: firmware.clean
	mkdir $(FIRMWARE.BUILD)
	cd $(FIRMWARE.BUILD) &&  export PATH=$(PATH):$(INSTALLED.HOST.DIR)/bin  export ARMGCC_DIR=$(TOOLCHAIN.DIR) && $(CMAKE.BIN) -DCMAKE_PROGRAM_PATH=$(INSTALLED.HOST.DIR)/bin -DCMAKE_MAKE_PROGRAM=/usr/bin/make -DWITH_BIG_ENDIAN=ON -DFREERTOS.DIR=$(FREERTOS.DIR) -DSOURCE_PATH=$(FIRMWARE.DIR) -DASF.DIR=$(ASF.DIR) -DCONFIG.DIR=$(CONFIG.DIR) -DLIBS_PATH=$(FIRMWARE.DIR)/libs -DUTILS.DIR=$(FIRMWARE.DIR)/utils -DTOOLCHAIN_DIR=$(TOOLCHAIN.DIR) -DCMAKE_LIBRARY_PATH=$(TOOLCHAIN.DIR)/arm-none-eabi/libc/usr/lib/thumb -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=$(BASE.DIR)/cortexm7.cmake -DCMAKE_PROGRAM_PATH=$(TOOLCHAIN.DIR)/bin -DCMAKE_CXX_COMPILER=$(TOOLCHAIN.DIR)/bin/arm-none-eabi-g++ -DCMAKE_C_COMPILER=$(TOOLCHAIN.DIR)/bin/arm-none-eabi-gcc $(FIRMWARE.DIR) && make -j4

firmware.sdram.release: firmware.clean
	mkdir $(FIRMWARE.BUILD)
	cd $(FIRMWARE.BUILD) &&  export ARMGCC_DIR=$(TOOLCHAIN.DIR) && $(CMAKE.BIN) -DCMAKE_LIBRARY_PATH=$(TOOLCHAIN.DIR)/arm-none-eabi/libc/usr/lib/thumb -DCMAKE_BUILD_TYPE=sdram_release -DCMAKE_TOOLCHAIN_FILE=$(BASE.DIR)/cortexm4.cmake -DCMAKE_PROGRAM_PATH=$(TOOLCHAIN.DIR)/bin -DCMAKE_CXX_COMPILER=$(TOOLCHAIN.DIR)/bin/arm-none-eabi-g++ -DCMAKE_C_COMPILER=$(TOOLCHAIN.DIR)/bin/arm-none-eabi-gcc $(FIRMWARE.DIR) && make -j4

firmware.sdram.debug: firmware.clean
	mkdir $(FIRMWARE.BUILD)
	cd $(FIRMWARE.BUILD) &&  export ARMGCC_DIR=$(TOOLCHAIN.DIR) && $(CMAKE.BIN) -DCMAKE_LIBRARY_PATH=$(TOOLCHAIN.DIR)/arm-none-eabi/libc/usr/lib/thumb -DCMAKE_BUILD_TYPE=sdram_debug -DCMAKE_TOOLCHAIN_FILE=$(BASE.DIR)/cortexm4.cmake -DCMAKE_PROGRAM_PATH=$(TOOLCHAIN.DIR)/bin -DCMAKE_CXX_COMPILER=$(TOOLCHAIN.DIR)/bin/arm-none-eabi-g++ -DCMAKE_C_COMPILER=$(TOOLCHAIN.DIR)/bin/arm-none-eabi-gcc $(FIRMWARE.DIR) && make -j4

flash: .FORCE
	$(OPENOCD.BIN) -f $(OPENOCD.CONFIG.FLASH)

gdb: .FORCE
	$(OPENOCD.BIN) -f $(OPENOCD.CONFIG.GDB)


bootstrap: toolchain cmake freertos hidapi openocd genromfs

toolchain: .FORCE
ifeq ($(OS), Linux)
	mkdir -p $(DOWNLOADS.DIR) && cd $(DOWNLOADS.DIR) && wget $(TOOLCHAIN.URL.LINUX)
	tar xvf $(TOOLCHAIN.ARCHIVE.LINUX)
endif

ifeq ($(OS), Darwin)
	mkdir -p $(DOWNLOADS.DIR) && cd $(DOWNLOADS.DIR) && wget $(TOOLCHAIN.URL.OSX)
	tar xvf $(TOOLCHAIN.ARCHIVE.OSX)
endif
toolchain.clean: .FORCE
	rm -rf $(TOOLCHAIN.ARCHIVE)
	rm -rf $(TOOLCHAIN.DIR)

firmware.clean: .FORCE
	rm -rf $(FIRMWARE.BUILD)

hidapi: hidapi.fetch
	cd $(HIDAPI.DIR) && ./bootstrap && ./configure --prefix=$(INSTALLED.HOST.DIR) && make -j4 install

hidapi.fetch: .FORCE
	rm -rf $(HIDAPI.DIR)
	cd $(DOWNLOADS.DIR) && wget $(HIDAPI.URL) && tar xvf $(HIDAPI.ARCHIVE)

freertos.clean: .FORCE
	rm -rf $(FREERTOS.ARCHIVE)
	rm -rf $(FREERTOS.DIR)

freertos.fetch: .FORCE
	cd $(DOWNLOADS.DIR) && wget $(FREERTOS.URL) && tar xvf $(FREERTOS.ARCHIVE)

freertos: freertos.fetch


openocd.clean: .FORCE
	rm -rf $(OPENOCD.ARCHIVE)
	rm -rf $(OPENOCD.DIR)

openocd.fetch: .FORCE
	cd $(DOWNLOADS.DIR) && wget $(OPENOCD.URL) && tar xvf $(OPENOCD.ARCHIVE)

openocd: openocd.clean openocd.fetch
ifeq ($(OS), Linux)
	cd $(OPENOCD.DIR) && HIDAPI_CFLAGS=-I$(INSTALLED.HOST.DIR)/include/hidapi HIDAPI_LIBS="-L$(INSTALLED.HOST.DIR)/lib -lhidapi-libusb" ./configure --prefix=$(INSTALLED.HOST.DIR) --enable-cmsis-dap && make -j4 install
endif

ifeq ($(OS), Darwin)
	cd $(OPENOCD.DIR) && HIDAPI_CFLAGS=-I$(INSTALLED.HOST.DIR)/include/hidapi HIDAPI_LIBS="-L$(INSTALLED.HOST.DIR)/lib -lhidapi" ./configure --prefix=$(INSTALLED.HOST.DIR) --enable-cmsis-dap && make -j4 install
endif


genromfs.clean: .FORCE
	rm -rf $(GENROMFS.ARCHIVE)
	rm -rf $(GENROMFS.DIR)

genromfs.fetch: .FORCE
	cd $(DOWNLOADS.DIR) && wget $(GENROMFS.URL) && tar xvf $(GENROMFS.ARCHIVE)

genromfs: genromfs.clean genromfs.fetch
	cd $(GENROMFS.DIR) &&  make -j4
	mv $(GENROMFS.DIR)/genromfs $(INSTALLED.HOST.DIR)/bin


cmake.fetch: .FORCE
	cd $(DOWNLOADS.DIR) && wget $(CMAKE.URL) && tar xvf $(CMAKE.ARCHIVE)

cmake: cmake.fetch
	cd $(CMAKE.DIR) && ./configure --prefix=$(INSTALLED.HOST.DIR) --no-system-zlib && make -j8 install

cmake.clean: .FORCE
	rm -rf $(CMAKE.ARCHIVE)
	rm -rf $(CMAKE.DIR)

clean: toolchain.clean firmware.clean cmake.clean

.FORCE:
