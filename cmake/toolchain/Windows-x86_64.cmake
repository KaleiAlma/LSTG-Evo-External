
if(NOT CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set(CMAKE_SYSTEM_NAME Windows)
endif()
# set(CMAKE_GENERATOR_PLATFORM "x86_64" CACHE INTERNAL "")

set(CMAKE_C_COMPILER cl)
set(CMAKE_CXX_COMPILER cl)
