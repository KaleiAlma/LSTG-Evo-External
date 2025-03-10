# sdl3

CPMAddPackage(
    NAME SDL3
    GITHUB_REPOSITORY libsdl-org/SDL
    GIT_TAG release-3.2.8
    OPTIONS
        "SDL_INSTALL ON"
        "SDL_INSTALL_CPACK OFF"
        "SDL_INSTALL_DOCS OFF"
        "SDL_INSTALL_TESTS OFF"
        "SDL_UNINSTALL OFF"
        "SDL_TEST OFF"
        "SDL_TEST_LIBRARY OFF"
        "SDL_SHARED ${BUILD_SHARED_LIBS}"
        "SDL_STATIC ${LSTGEXT_BUILD_STATIC_LIBS}"
        "SDL_ASSEMBLY ON"
        "SDL_MMX ${LSTG_x86_64}"
        "SDL_SSE ${LSTG_x86_64}"
        "SDL_SSE2 ${LSTG_x86_64}"
        "SDL_SSE3 ${LSTG_SSE4_2}"
        "SDL_SSE4_1 ${LSTG_SSE4_2}"
        "SDL_SSE4_2 ${LSTG_SSE4_2}"
        "SDL_AVX ${LSTG_AVX}"
        "SDL_AVX2 ${LSTG_AVX2}"
        "SDL_AVX512F ${LSTG_AVX512F}"
        "SDL_RENDER OFF"
)

if(BUILD_SHARED_LIBS)
    lstgext_tgtopts_unicode(SDL3-shared)
else()
    lstgext_tgtopts_unicode(SDL3-static)
endif()


# sdl_shadercross

if(WIN32 AND NOT MINGW)
    include_directories("$ENV{VSINSTALLDIR}\\DIA SDK\\include\\")
endif()

CPMAddPackage(
    NAME SDL_shadercross
    GITHUB_REPOSITORY libsdl-org/SDL_shadercross
    GIT_TAG db758697661c59718ae02786d667d24f94d3c88b
    PATCHES "DXShader.patch"
    OPTIONS
        "SDLSHADERCROSS_INSTALL ON"
        "SDLSHADERCROSS_DXC ON"
        "SDLSHADERCROSS_SPIRVCROSS_SHARED ${BUILD_SHARED_LIBS}"
        "SDLSHADERCROSS_SHARED ${BUILD_SHARED_LIBS}"
        "SDLSHADERCROSS_STATIC ${LSTGEXT_BUILD_STATIC_LIBS}"
        "SDLSHADERCROSS_VENDORED ON"
        "SPIRV_WERROR OFF"
)

if(BUILD_SHARED_LIBS)
    lstgext_tgtopts_full(SDL3_shadercross-shared)
else()
    lstgext_tgtopts_full(SDL3_shadercross-static)
endif()


# glslang

CPMAddPackage(
    NAME glslang
    GITHUB_REPOSITORY KhronosGroup/glslang
    GIT_TAG 15.1.0
    OPTIONS
        "BUILD_EXTERNAL OFF"
        "ENABLE_GLSLANG_JS OFF"
        "ENABLE_SPVREMAPPER OFF"
        "GLSLANG_ENABLE_INSTALL ON"
)


# g-truc glm
# OpenGL math library

CPMAddPackage(
    NAME glm
    GITHUB_REPOSITORY g-truc/glm
    GIT_TAG 1.0.1
    OPTIONS
        "GLM_ENABLE_CXX_20 ON"
        "GLM_ENABLE_SIMD_SSE2 ${LSTG_x86_64}"
        "GLM_ENABLE_SIMD_SSE4_2 ${LSTG_SSE4_2}"
        "GLM_ENABLE_SIMD_AVX ${LSTG_AVX}"
        "GLM_ENABLE_SIMD_AVX2 ${LSTG_AVX2}"
        "GLM_BUILD_LIBRARY ON"
        "GLM_BUILD_INSTALL ON"
)
lstgext_tgtopts_full(glm)

list(APPEND LSTG_EXTERNAL_ALL_INCDIRS ${glm_SOURCE_DIR}/glm)

# tinygltf
# Parser for gltf 2.0 files

CPMAddPackage(
    NAME tinygltf
    VERSION 2.8.14
    GITHUB_REPOSITORY syoyo/tinygltf
    DOWNLOAD_ONLY YES
)

file(WRITE ${CMAKE_BINARY_DIR}/tinygltf/tiny_gltf.h "PLACEHOLD")
file(REMOVE
    ${CMAKE_BINARY_DIR}/tinygltf/tiny_gltf.h
)
file(COPY_FILE
    ${tinygltf_SOURCE_DIR}/tiny_gltf.h
    ${CMAKE_BINARY_DIR}/tinygltf/tiny_gltf.h
)

list(APPEND LSTG_EXTERNAL_SOURCES ${CMAKE_BINARY_DIR}/tinygltf/tiny_gltf.h)
list(APPEND LSTG_EXTERNAL_HEADERS ${CMAKE_BINARY_DIR}/tinygltf/tiny_gltf.h)
list(APPEND LSTG_EXTERNAL_DEFINES TINYGLTF_IMPLEMENTATION)
list(APPEND LSTG_EXTERNAL_INCDIRS $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/tinygltf>)


# freetype
# Font utilities

CPMAddPackage(
    NAME freetype
    GITHUB_REPOSITORY freetype/freetype
    GIT_TAG VER-2-13-3
    OPTIONS
        "FT_DISABLE_ZLIB ON"
        "FT_DISABLE_BZIP2 ON"
        "FT_DISABLE_PNG ON"
        "FT_DISABLE_HARFBUZZ ON"
        "FT_DISABLE_BROTLI ON"
)

lstgext_tgtopts_full(freetype)
if(MSVC)
    target_compile_options(freetype PRIVATE
        "/utf-8" # Unicode warning
    )
endif()
set_target_properties(freetype PROPERTIES FOLDER external)

list(APPEND LSTG_EXTERNAL_ALL_INCDIRS ${freetype_SOURCE_DIR}/include/freetype)
