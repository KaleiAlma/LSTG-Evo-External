# nlohmann json
# JSON parser and writer

CPMAddPackage(
    NAME nlohmann_json
    VERSION 3.11.2
    GITHUB_REPOSITORY nlohmann/json
    OPTIONS
    "JSON_BuildTests OFF"
)
luastg_external_target_common_options(nlohmann_json)

# gabime spdlog
# Logging utility

CPMAddPackage(
    NAME spdlog
    VERSION 1.12.0
    GITHUB_REPOSITORY gabime/spdlog
    OPTIONS
    # "SPDLOG_WCHAR_FILENAMES ON"
    # "SPDLOG_WCHAR_SUPPORT ON"
    "SPDLOG_DISABLE_DEFAULT_LOGGER ON"
)

luastg_external_target_common_options(spdlog)

if(TARGET spdlog)
    if(MSVC)
        target_compile_options(spdlog PUBLIC
            "/DSPDLOG_SHORT_LEVEL_NAMES={\"V\",\"D\",\"I\",\"W\",\"E\",\"F\",\"O\"}"
        )
    endif()
    set_target_properties(spdlog PROPERTIES FOLDER external)
endif()

# pugixml
# XML file support

CPMAddPackage(
    NAME pugixml
    VERSION 1.13
    GITHUB_REPOSITORY zeux/pugixml
    DOWNLOAD_ONLY YES
)

if(pugixml_ADDED)
    # pugixml's CMake support kinda sucks, so we do it ourself.
    add_library(pugixml STATIC)
    luastg_external_target_common_options(pugixml)
    target_include_directories(pugixml PUBLIC
        ${pugixml_SOURCE_DIR}/src
    )
    target_sources(pugixml PRIVATE
        ${pugixml_SOURCE_DIR}/src/pugiconfig.hpp
        ${pugixml_SOURCE_DIR}/src/pugixml.hpp
        ${pugixml_SOURCE_DIR}/src/pugixml.cpp
    )
    set(pugixml_natvis ${pugixml_SOURCE_DIR}/scripts/natvis/pugixml.natvis)
    source_group(TREE ${pugixml_SOURCE_DIR}/scripts FILES ${pugixml_natvis})
    target_sources(pugixml PUBLIC
        ${pugixml_natvis}
    )
    set_target_properties(pugixml PROPERTIES FOLDER external)
endif()

# nothings stb
# Misc tools

CPMAddPackage(
    NAME nothings_stb
    GITHUB_REPOSITORY nothings/stb
    GIT_TAG ae721c50eaf761660b4f90cc590453cdb0c2acd0
    DOWNLOAD_ONLY YES
)

if(nothings_stb_ADDED)
    # stb does not come with CMake support
    add_library(nothings_stb STATIC)
    luastg_external_target_common_options(nothings_stb)
    target_include_directories(nothings_stb PUBLIC
        ${nothings_stb_SOURCE_DIR}
        ${CMAKE_BINARY_DIR}/nothings_stb/include
    )
    file(WRITE ${CMAKE_BINARY_DIR}/nothings_stb/include/stb_vorbis.h
        "#define STB_VORBIS_HEADER_ONLY\n"
        "#include \"stb_vorbis.c\"\n"
        "#undef STB_VORBIS_HEADER_ONLY\n"
    )
    file(WRITE ${CMAKE_BINARY_DIR}/nothings_stb/nothings_stb.c
        "#define STB_IMAGE_IMPLEMENTATION\n"
        "#include \"stb_image.h\"\n"
        "#include \"stb_vorbis.c\"\n"
    )
    target_sources(nothings_stb PRIVATE
        ${CMAKE_BINARY_DIR}/nothings_stb/include/stb_vorbis.h
        ${nothings_stb_SOURCE_DIR}/stb_image.h
        ${CMAKE_BINARY_DIR}/nothings_stb/nothings_stb.c
    )
    set_target_properties(nothings_stb PROPERTIES FOLDER external)
endif()

# # dr_libs
# # Decode WAV and MP3 files

# CPMAddPackage(
#     NAME dr_libs
#     GITHUB_REPOSITORY mackron/dr_libs
#     GIT_TAG e07e2b8264da5fa1331a0ca3d30a3606084c311f
#     DOWNLOAD_ONLY YES
# )

# if(dr_libs_ADDED)
#     # dr_libs does not come with CMake support
#     add_library(dr_libs STATIC)
#     target_include_directories(dr_libs PUBLIC
#         ${dr_libs_SOURCE_DIR}
#     )
#     file(WRITE ${CMAKE_BINARY_DIR}/dr_libs/dr_libs.c
#         "#define DR_WAV_IMPLEMENTATION\n"
#         "#define DR_MP3_IMPLEMENTATION\n"
#         "#define DR_FLAC_IMPLEMENTATION\n"
#         "#include \"dr_wav.h\"\n"
#         "#include \"dr_mp3.h\"\n"
#         "#include \"dr_flac.h\"\n"
#     )
#     target_sources(dr_libs PRIVATE
#         ${dr_libs_SOURCE_DIR}/dr_wav.h
#         ${dr_libs_SOURCE_DIR}/dr_mp3.h
#         ${dr_libs_SOURCE_DIR}/dr_flac.h
#         ${CMAKE_BINARY_DIR}/dr_libs/dr_libs.c
#     )
#     set_target_properties(dr_libs PROPERTIES FOLDER external)
# endif()

# pcg random
# High-quality RNG

CPMAddPackage(
    NAME pcg_cpp
    GITHUB_REPOSITORY imneme/pcg-cpp
    GIT_TAG 428802d1a5634f96bcd0705fab379ff0113bcf13
    DOWNLOAD_ONLY YES
)

if(pcg_cpp_ADDED)
    add_library(pcg_cpp INTERFACE)
    luastg_external_target_common_options(pcg_cpp)
    target_include_directories(pcg_cpp INTERFACE
        ${pcg_cpp_SOURCE_DIR}/include
    )
endif()

# xxhash
# High-quality high-performance hash lib (not password-secure)

CPMAddPackage(
    NAME xxhash
    VERSION 0.8.1
    GITHUB_REPOSITORY Cyan4973/xxHash
    DOWNLOAD_ONLY YES
)

if(xxhash_ADDED)
    add_library(xxhash STATIC)
    luastg_external_target_common_options(xxhash)
    set_target_properties(xxhash PROPERTIES
        C_STANDARD 17
        C_STANDARD_REQUIRED ON
        CXX_STANDARD 20
        CXX_STANDARD_REQUIRED ON
    )
    target_include_directories(xxhash PUBLIC
        ${xxhash_SOURCE_DIR}
    )
    target_sources(xxhash PRIVATE
        ${xxhash_SOURCE_DIR}/xxhash.c
        ${xxhash_SOURCE_DIR}/xxhash.h
    )
    set_target_properties(xxhash PROPERTIES FOLDER external)
endif()

# uni-algo
# Unicode utilities

CPMAddPackage(
    NAME uni-algo
    VERSION 1.2.0
    GITHUB_REPOSITORY uni-algo/uni-algo
    OPTIONS
)
luastg_external_target_common_options(uni-algo)
