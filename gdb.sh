#!/bin/sh
gcc-arm-none-eabi-7-2017-q4-major/bin/arm-none-eabi-gdb -s build.firmware/firmware.elf -ex "target remote localhost:3333"


