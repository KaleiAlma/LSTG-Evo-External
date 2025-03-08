
if(NOT CMAKE_HOST_SYSTEM_NAME EQUAL "Linux")
    set(CMAKE_SYSTEM_NAME Linux)
endif()

set(CMAKE_C_COMPILER clang-19)
set(CMAKE_CXX_COMPILER clang++-19)

if(NOT CMAKE_HOST_SYSTEM_PROCESSOR EQUAL x86_64)
    set(CMAKE_C_COMPILER_TARGET x86_64-linux-gnu)
    set(CMAKE_CXX_COMPILER_TARGET x86_64-linux-gnu)
endif()

set(CMAKE_LINKER_TYPE LLD)
