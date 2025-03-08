
set(CMAKE_SYSTEM_NAME Windows)
# set(CMAKE_GENERATOR_PLATFORM "x86_64" CACHE INTERNAL "")

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

if(NOT CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(CMAKE_C_COMPILER_TARGET x86_64-windows-msvc)
    set(CMAKE_CXX_COMPILER_TARGET x86_64-windows-msvc)
endif()
