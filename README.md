# Linux Host Environment Setup
## Install Dependencies
```bash
sudo apt-get install build-essential git
```

## Update UDEV Rules
Add this line to the end of /etc/udev/rules.d/99-same70.rules
```bash
SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", MODE="0664", GROUP="plugdev"
```

Reload UDEV Rules
```bash
sudo udevadm control --reload-rules
```


# Setup Source Tree & Build Firmware Release
```bash
git clone git@github.com:caseykelso/microchip-same70xplained-freertos.git
cd microchip-same70xplained-freertos
make bootstrap
make
```

# Build Firmware for Release
```bash
make
or
make firmware.release
```

# Build Firmware for Debug
```bash
make firmware.debug
```

# Flash Firmware
```bash
make flash
```

# Start Debugger
## Setup Device-side Debugger
```bash
make gdb
```

## Setup Host-side Debugger
```bash
./gdb.sh
````


