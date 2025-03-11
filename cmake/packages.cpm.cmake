# nlohmann json
# JSON parser and writer

CPMAddPackage(
    NAME nlohmann_json
    VERSION 3.11.2
    GITHUB_REPOSITORY nlohmann/json
    OPTIONS
    "JSON_BuildTests OFF"
    "JSON_Install ON"
)


# gabime spdlog
# Logging utility

if(WIN32)
    set(SPDLOG_WIN32_OPTS
        "SPDLOG_WCHAR_FILENAMES ON"
        "SPDLOG_WCHAR_SUPPORT ON"
    )
endif()

CPMAddPackage(
    NAME spdlog
    VERSION 1.12.0
    GITHUB_REPOSITORY gabime/spdlog
    OPTIONS
    ${SPDLOG_WIN32_OPTS}
    "SPDLOG_DISABLE_DEFAULT_LOGGER ON"
    "SPDLOG_INSTALL ON"
)

lstgext_tgtopts_full(spdlog)

if(MSVC)
    target_compile_options(spdlog PUBLIC
        "/DSPDLOG_SHORT_LEVEL_NAMES={\"V\",\"D\",\"I\",\"W\",\"E\",\"F\",\"O\"}"
    )
endif()
set_target_properties(spdlog PROPERTIES FOLDER external)


# nothings stb
# Misc tools

CPMAddPackage(
    NAME nothings_stb
    GITHUB_REPOSITORY nothings/stb
    GIT_TAG 5c205738c191bcb0abc65c4febfa9bd25ff35234
    DOWNLOAD_ONLY YES
)

list(APPEND LSTG_EXTERNAL_SOURCES
    ${nothings_stb_SOURCE_DIR}/stb_vorbis.c
    ${nothings_stb_SOURCE_DIR}/stb_image.h
    ${nothings_stb_SOURCE_DIR}/stb_image_write.h
    ${nothings_stb_SOURCE_DIR}/stb_rect_pack.h
 )
list(APPEND LSTG_STB_HEADERS
    ${nothings_stb_SOURCE_DIR}/stb_image.h
    ${nothings_stb_SOURCE_DIR}/stb_image_write.h
    ${nothings_stb_SOURCE_DIR}/stb_rect_pack.h
)
list(APPEND LSTG_STB_BASEDIRS ${nothings_stb_SOURCE_DIR})
list(APPEND LSTG_EXTERNAL_DEFINES
    STB_IMAGE_IMPLEMENTATION
    STB_IMAGE_WRITE_IMPLEMENTATION
    STB_RECT_PACK_IMPLEMENTATION
)


# pcg random
# High-quality RNG

CPMAddPackage(
    NAME pcg_cpp
    GITHUB_REPOSITORY imneme/pcg-cpp
    GIT_TAG 428802d1a5634f96bcd0705fab379ff0113bcf13
    DOWNLOAD_ONLY YES
)

file(GLOB LSTG_PCG_HEADERS ${pcg_cpp_SOURCE_DIR}/include/*.hpp)
list(APPEND LSTG_PCG_BASEDIRS ${pcg_cpp_SOURCE_DIR}/include)


# xxhash
# High-quality high-performance hash lib (not password-secure)

CPMAddPackage(
    NAME xxhash
    VERSION 0.8.1
    GITHUB_REPOSITORY Cyan4973/xxHash
    DOWNLOAD_ONLY YES
    PATCHES "xxhash.patch"
)

list(APPEND LSTG_EXTERNAL_SOURCES ${xxhash_SOURCE_DIR}/xxhash.c)
list(APPEND LSTG_EXTERNAL_HEADERS ${xxhash_SOURCE_DIR}/xxhash.h)
list(APPEND LSTG_EXTERNAL_INCDIRS ${xxhash_SOURCE_DIR})


# uni-algo
# Unicode utilities

CPMAddPackage(
    NAME uni-algo
    VERSION 1.2.0
    GITHUB_REPOSITORY uni-algo/uni-algo
    OPTIONS
        "UNI_ALGO_INSTALL ON"
)
lstgext_tgtopts_full(uni-algo)


# tracy
# Profiler

# hack to fix include dirs
set(_CMAKE_INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR})
set(CMAKE_INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR}/tracy)

CPMAddPackage(
    NAME tracy
    VERSION 0.11.1
    GITHUB_REPOSITORY wolfpld/tracy
    OPTIONS
        "TRACY_ENABLE OFF"
)
lstgext_tgtopts_full(TracyClient)

# reset hack
set(CMAKE_INSTALL_INCLUDEDIR ${_CMAKE_INSTALL_INCLUDEDIR})
