include(CMakeForceCompiler)

# this one is important
set(CMAKE_SYSTEM_NAME Generic)

# this one not so much
set(CMAKE_SYSTEM_VERSION 1)

# specify the cross compiler
find_program(C_COMPILER arm-none-eabi-gcc)
if(NOT C_COMPILER)
	message(FATAL_ERROR "could not find arm-none-eabi-gcc compiler")
endif()
cmake_force_c_compiler(${C_COMPILER} GNU)

find_program(CXX_COMPILER arm-none-eabi-g++)
if(NOT CXX_COMPILER)
	message(FATAL_ERROR "could not find arm-none-eabi-g++ compiler")
endif()
cmake_force_cxx_compiler(${CXX_COMPILER} GNU)

# compiler tools
foreach(tool objcopy nm ld)
	string(TOUPPER ${tool} TOOL)
	find_program(${TOOL} arm-none-eabi-${tool})
	if(NOT ${TOOL})
		message(FATAL_ERROR "could not find ${tool}")
	endif()
endforeach()

# optional compiler tools
foreach(tool gdb gdbtui)
	string(TOUPPER ${tool} TOOL)
	find_program(${TOOL} arm-none-eabi-${tool})
	if(NOT ${TOOL})
		#message(STATUS "could not find ${tool}")
	endif()
endforeach()

# os tools
foreach(tool echo patch grep rm mkdir nm genromfs cp touch make unzip)
	string(TOUPPER ${tool} TOOL)
	find_program(${TOOL} ${tool})
	if(NOT ${TOOL})
		message(FATAL_ERROR "could not find ${tool}")
	endif()
endforeach()

# optional os tools
foreach(tool ddd)
	string(TOUPPER ${tool} TOOL)
	find_program(${TOOL} ${tool})
	if(NOT ${TOOL})
		#message(STATUS "could not find ${tool}")
	endif()
endforeach()

# 
set(cpu_flags "-mcpu=cortex-m7   -mthumb -pipe -fno-strict-aliasing -Wall -Wstrict-prototypes -Wmissing-prototypes -Werror-implicit-function-declaration -Wpointer-arith -std=gnu99 -ffunction-sections -fdata-sections -Wchar-subscripts -Wcomment -Wformat=2 -Wimplicit-int -Wmain -Wparentheses -Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs -Wunused -Wuninitialized -Wunknown-pragmas -Wfloat-equal -Wundef -Wshadow -Wbad-function-cast -Wwrite-strings -Wsign-compare -Waggregate-return -Wmissing-declarations -Wformat -Wmissing-format-attribute -Wno-deprecated-declarations -Wpacked -Wredundant-decls -Wnested-externs -Wlong-long -Wunreachable-code -Wcast-align --param max-inline-insns-single=500 -mfloat-abi=softfp -mfpu=fpv5-sp-d16")

set(sys_specs "--specs=nosys.specs")

set(CMAKE_C_FLAGS_RELEASE " -O3  ${cpu_flags}"  CACHE INTERNAL  "" )#FORCE)
set(CMAKE_CXX_FLAGS_RELEASE " ${sys.specs} -O3  ${cpu_flags}" CACHE INTERNAL "") # FORCE)
set(CMAKE_C_FLAGS_DEBUG " ${sys.specs} -O0 -ggdb  ${cpu_flags}" CACHE INTERNAL "") # FORCE)
set(CMAKE_CXX_FLAGS_DEBUG " ${sys.specs} -O0 -ggdb  ${cpu_flags}" CACHE INTERNAL "") # FORCE)
set(CMAKE_ASM_FLAGS "${cpu_flags}  -DARM_MATH_CM7=true -DBOARD=SAME70_XPLAINED -D__SAME70Q21__ -Dprintf=iprintf -Dscanf=iscanf" CACHE INTERNAL "") # FORCE)

#set(CMAKE_EXE_LINKER_FLAGS "${cpu_flags} -nodefaultlibs -nostdlib -Wl,--warn-common,--gc-sections" CACHE INTERNAL "" FORCE)
set(CMAKE_EXE_LINKER_FLAGS "${cpu_flags} ${sys_specs} -Wl,--entry=Reset_Handler -Wl,--cref -mthumb -T${ASF.DIR}/sam/utils/linker_scripts/same70/same70q21/gcc/flash.ld "    CACHE INTERNAL ""  FORCE)

# where is the target environment 
set(CMAKE_FIND_ROOT_PATH get_file_component(${C_COMPILER} PATH))

# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

