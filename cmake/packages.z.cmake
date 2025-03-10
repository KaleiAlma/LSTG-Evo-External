# minizip
# Load zip files

# minizip generally misbehaves under clang on windows - use msvc for it instead
if(WIN32 AND NOT MSVC)
    execute_process(
        COMMAND git clone -b 4.0.8 https://github.com/zlib-ng/minizip-ng ${CMAKE_CURRENT_BINARY_DIR}/minizip_ng-src
        COMMAND ${CMAKE_COMMAND}
            -S ${CMAKE_CURRENT_BINARY_DIR}/minizip_ng-src
            -B ${CMAKE_CURRENT_BINARY_DIR}/minizip_ng-build
            -G ${CMAKE_GENERATOR}
            -DCMAKE_C_COMPILER=cl
            -DCMAKE_CXX_COMPILER=cl
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_INSTALL_LIBDIR=${CMAKE_INSTALL_LIBDIR}
            -DCMAKE_SKIP_INSTALL_ALL_DEPENDENCY=TRUE
            -DSKIP_INSTALL_ALL=FALSE
            -DSKIP_INSTALL_LIBRARIES=FALSE
            -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
            -DBUILD_TESTING=OFF
            -DZLIB_ENABLE_TESTS=OFF
            -DZLIBNG_ENABLE_TESTS=OFF
            -DWITH_GTEST=OFF
            -DMZ_FETCH_LIBS=ON
            -DZLIB_REPOSITORY=https://github.com/zlib-ng/zlib-ng
            -DZLIB_TAG=2.2.4
            -DZSTD_TAG=v1.5.7
            -DWITH_SSE2=${LSTG_x86_64}
            -DWITH_SSSE3=${LSTG_SSE4_2}
            -DWITH_SSE42=${LSTG_SSE4_2}
            -DWITH_AVX2=${LSTG_AVX2}
            -DWITH_AVX512=${LSTG_AVX512F}
    )
    add_custom_target(minizip
        COMMAND ${CMAKE_COMMAND} --build ${CMAKE_CURRENT_BINARY_DIR}/minizip_ng-build --target minizip
        COMMAND ${CMAKE_COMMAND} --install ${CMAKE_CURRENT_BINARY_DIR}/minizip_ng-build
        BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/minizip_ng-build/minizip.lib
    )
    link_directories(${CMAKE_CURRENT_BINARY_DIR}/minizip_ng-build)
else()
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
            "WITH_SSE2 ${LSTG_x86_64}"
            "WITH_SSSE3 ${LSTG_SSE4_2}"
            "WITH_SSE42 ${LSTG_SSE4_2}"
            "WITH_AVX2 ${LSTG_AVX2}"
            "WITH_AVX512 ${LSTG_AVX512F}"
    )
endif()


if(LINUX AND LSTG_ARM64 AND CMAKE_CROSSCOMPILING) # lld is broken when cross-compiling
    set_target_properties(minizip PROPERTIES LINKER_TYPE BFD)
endif()

# thankfully i figured out how to make zlib-ng/minizip-ng play nice ig