set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(CMAKE_FIND_ROOT_PATH $ENV{XBSTRAP_SYSROOT_DIR})

set(CMAKE_C_COMPILER x86_64-crescent-gcc)
set(CMAKE_CXX_COMPILER x86_64-crescent-g++)
set(CMAKE_AR x86_64-crescent-ar)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
