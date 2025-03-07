# minizip
# Load zip files


CPMAddPackage(
    NAME minizip_ng
    GITHUB_REPOSITORY zlib-ng/minizip-ng
    GIT_TAG 4.0.8
    OPTIONS
        "ZLIB_ENABLE_TESTS OFF"
        "ZLIBNG_ENABLE_TESTS OFF"
        "WITH_GTEST OFF"
        "MZ_FETCH_LIBS ON"
        "ZLIB_REPOSITORY https://github.com/zlib-ng/zlib-ng"
        "ZLIB_TAG 2.2.4"
        "ZSTD_TAG v1.5.7"
)

if(LINUX AND LSTG_ARM64 AND CMAKE_CROSSCOMPILING) # lld is broken when cross-compiling
    set_target_properties(minizip PROPERTIES LINKER_TYPE BFD)
endif()

# thankfully i figured out how to make zlib-ng/minizip-ng play nice ig