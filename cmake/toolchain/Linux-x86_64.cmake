
if(NOT CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
    set(CMAKE_SYSTEM_NAME Linux)
endif()
if(NOT CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(CMAKE_SYSTEM_NAME Linux)
    set(CMAKE_SYSTEM_PROCESSOR x86_64)
endif()

set(CMAKE_C_COMPILER clang-19)
set(CMAKE_CXX_COMPILER clang++-19)

set(CMAKE_LINKER_TYPE LLD)

set(CMAKE_C_COMPILER_TARGET x86_64-linux-gnu)
set(CMAKE_CXX_COMPILER_TARGET x86_64-linux-gnu)
