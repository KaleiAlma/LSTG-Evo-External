# minizip
# Load zip files


CPMAddPackage(
    NAME minizip_ng
    VERSION 4.0.5
    GITHUB_REPOSITORY zlib-ng/minizip-ng
    GIT_TAG 4.0.5
    OPTIONS
        "ZLIB_ENABLE_TESTS OFF"
        "ZLIBNG_ENABLE_TESTS OFF"
        "WITH_GTEST OFF"
        "ZLIB_REPOSITORY https://github.com/zlib-ng/zlib-ng"
        "ZLIB_TAG 2.1.6"
        "ZSTD_TAG v1.5.6"
)

# thankfully i figured out how to make zlib-ng/minizip-ng play nice ig