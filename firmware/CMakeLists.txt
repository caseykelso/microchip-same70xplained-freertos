CMAKE_MINIMUM_REQUIRED(VERSION 3.2.2)
#set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER_TARGET gcc_ntoarmv7le)
set(CMAKE_CXX_COMPILER_TARGET gcc_ntoarmv7le)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_CROSSCOMPILING true)
#set(CMAKE_SYSROOT="/")
set(CMAKE_SYSTEM_LIBRARY_PATH ${GCCLIB_DIR})
set(CMAKE_LIBRARY_PATH ${GCCLIB_DIR})

set(FREERTOS.COMMON.DIR ${FREERTOS.DIR}/FreeRTOS/Demo/Common)
set(FREERTOS.SOURCE.DIR ${FREERTOS.DIR}/FreeRTOS/Source)
set(FREERTOS.TEMPLATES.DIR ${FREERTOS.DIR}/FreeRTOS/Demo/CORTEX_M7_SAME70_Xplained_AtmelStudio/src/ASF/sam/utils/cmsis/same70/source/templates)


include_directories(${GCC_PATH}/include)
include_directories(${GCC_PATH}/arm-none-eabi/include/c++/7.2.1)
include_directories(${ASF.DIR}/sam/utils/cmsis/same70/include/component)
include_directories(${ASF.DIR}/sam/utils/cmsis/same70/include)
include_directories(${ASF.DIR}/sam/drivers/pio)
include_directories(${ASF.DIR}/common/services/clock)
include_directories(${ASF.DIR}/sam/utils/preprocessor)
include_directories(${ASF.DIR}/sam/utils/cmsis/same70/include/instance)
include_directories(${ASF.DIR}/common/utils)
include_directories(${ASF.DIR}/sam/utils/cmsis/same70)
include_directories(${ASF.DIR}/drivers/matrix)
include_directories(${ASF.DIR}/sam/utils/fpu)
include_directories(${ASF.DIR}/thirdparty/CMSIS/Include)
include_directories(${ASF.DIR}/sam/utils)
include_directories(${ASF.DIR}/sam/drivers/pmc)
include_directories(${ASF.DIR}/sam/drivers/uart)
include_directories(${ASF.DIR}/common/services/ioport/sam)
include_directories(${ASF.DIR}/common/services/ioport)
include_directories(${ASF.DIR}/utils/cmsis/same70/include/pio)
include_directories(${ASF.DIR}/common/services/gpio)
include_directories(${ASF.DIR}/common/utils/interrupt)
include_directories(${ASF.DIR}/sam/boards/same70_xplained)
include_directories(${ASF.DIR}/common/services/gpio/sam_gpio)
include_directories(${ASF.DIR}/sam/drivers/mpu)
include_directories(${ASF.DIR}/sam/drivers/tc)
include_directories(${ASF.DIR}/sam/utils/header_files)
include_directories(${ASF.DIR}/common/services/serial)
include_directories(${CONFIG.DIR})
include_directories(${SOURCE_PATH}/src)
include_directories(${SOURCE_PATH}/src/Full_Demo)
include_directories(${ASF.DIR}/common/boards)
include_directories(${FREERTOS.DIR}/FreeRTOS/Source/include)
include_directories(${FREERTOS.DIR}/FreeRTOS/Source/portable/GCC/ARM_CM7/r0p1)
include_directories(${FREERTOS.DIR}/FreeRTOS/Demo/Common/include)
include_directories(${ASF.DIR}/common/utils/stdio/stdio_serial)
include_directories(${ASF.DIR}/common/services/serial/sam_uart)
include_directories(${ASF.DIR})
include_directories(${FREERTOS.TEMPLATES.DIR})
include_directories(${ASF.DIR}/sam/boards)
include_directories(${SOURCE_PATH})
link_directories(${GCC_LIB_DIR})
set(SAM_SOURCES ${ASF.DIR}/common/utils/stdio/read.c ${ASF.DIR}/common/utils/stdio/write.c)

add_definitions(-DDONT_USE_CMSIS_INIT)
add_definitions(-DF_CPU=150000000)  # peripheral frequency
add_definitions(-DSAM=1 )
add_definitions(-DARM_MATH_CM7=true -DBOARD=SAME70_XPLAINED -D__SAME70Q21__ -Dprintf=iprintf -Dscanf=iscanf )
add_definitions(-D__FPU_USED=1)

add_executable(firmware.elf
               ${FREERTOS.TEMPLATES.DIR}/system_same70.c
               ${FREERTOS.TEMPLATES.DIR}/gcc/startup_same70.c
               ${FREERTOS.COMMON.DIR}/Minimal/BlockQ.c
               ${FREERTOS.COMMON.DIR}/Minimal/blocktim.c
               ${FREERTOS.COMMON.DIR}/Minimal/countsem.c
               ${FREERTOS.COMMON.DIR}/Minimal/death.c
               ${FREERTOS.COMMON.DIR}/Minimal/dynamic.c
               ${FREERTOS.COMMON.DIR}/Minimal/EventGroupsDemo.c
               ${FREERTOS.COMMON.DIR}/Minimal/flop.c
               ${FREERTOS.COMMON.DIR}/Minimal/GenQTest.c
               ${FREERTOS.COMMON.DIR}/Minimal/IntSemTest.c
               ${FREERTOS.COMMON.DIR}/Minimal/QueueOverwrite.c
               ${FREERTOS.COMMON.DIR}/Minimal/semtest.c
               ${FREERTOS.COMMON.DIR}/Minimal/TaskNotify.c
               ${FREERTOS.COMMON.DIR}/Minimal/recmutex.c
               ${FREERTOS.COMMON.DIR}/Minimal/TimerDemo.c
               ${FREERTOS.COMMON.DIR}/Minimal/IntQueue.c
#               ${ASF.DIR}/sam/utils/syscalls/gcc/syscalls.c
               ${ASF.DIR}/common/services/clock/same70/sysclk.c
               ${ASF.DIR}/common/services/serial/usart_serial.c
               ${ASF.DIR}/common/utils/interrupt/interrupt_sam_nvic.c
               ${ASF.DIR}/sam/boards/same70_xplained/init.c
               ${ASF.DIR}/sam/drivers/matrix/matrix.c
               ${ASF.DIR}/sam/drivers/pio/pio.c
               ${ASF.DIR}/sam/drivers/mpu/mpu.c
               ${ASF.DIR}/sam/drivers/pio/pio_handler.c
               ${ASF.DIR}/sam/drivers/pmc/pmc.c
               ${ASF.DIR}/sam/drivers/pmc/sleep.c
               ${ASF.DIR}/sam/drivers/tc/tc.c
               ${ASF.DIR}/sam/drivers/uart/uart.c
               ${ASF.DIR}/sam/drivers/usart/usart.c
               
               src/Full_Demo/main_full.c 
               src/main.c
               src/Blinky_Demo/main_blinky.c
               src/Full_Demo/IntQueueTimer.c 
               src/Full_Demo/RegTest_GCC.c
               ${FREERTOS.SOURCE.DIR}/tasks.c
               ${FREERTOS.SOURCE.DIR}/queue.c
               ${FREERTOS.SOURCE.DIR}/timers.c
               ${FREERTOS.SOURCE.DIR}/portable/MemMang/heap_4.c
               ${FREERTOS.SOURCE.DIR}/list.c
               ${FREERTOS.SOURCE.DIR}/event_groups.c
               ${FREERTOS.SOURCE.DIR}/portable/GCC/ARM_CM7/r0p1/port.c
               ${SAM_SOURCES})

link_directories(${ASF.DIR}/thirdparty/CMSIS/lib/GCC)
target_link_libraries(firmware.elf m)
#target_link_libraries(app STATIC arm_cortexM7lfsp_math.a arm_cortexM7lfsp_math_softfp.a)

#link_directories(${MBED_INCLUDE})


