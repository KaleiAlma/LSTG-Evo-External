if(WIN32 AND NOT MINGW)
    set(INSTALL_CMAKEDIR_ROOT "cmake")
else()
    set(INSTALL_CMAKEDIR_ROOT "${CMAKE_INSTALL_LIBDIR}/cmake")
endif()

# spir-v

CPMAddPackage(
    NAME SPIRV-Headers
    GITHUB_REPOSITORY KhronosGroup/SPIRV-Headers
    GIT_TAG 54a521dd130ae1b2f38fef79b09515702d135bdd
    GIT_SHALLOW ON
    GIT_SUBMODULES_RECURSE OFF
    OPTIONS
        "SPIRV_HEADERS_ENABLE_INSTALL ON"
)

CPMAddPackage(
    NAME SPIRV-Tools
    GITHUB_REPOSITORY KhronosGroup/SPIRV-Tools
    GIT_TAG v2025.1.rc1
    GIT_SHALLOW ON
    GIT_SUBMODULES_RECURSE OFF
    OPTIONS
        "SPIRV_WERROR OFF"
        "SPIRV_SKIP_EXECUTABLES ON"
        "SKIP_SPIRV_TOOLS_INSTALL ON"
        "SPIRV_TOOLS_BUILD_STATIC ON"
)

install(TARGETS SPIRV-Tools-opt SPIRV-Tools-static EXPORT SPIRV-Tools)
export(TARGETS SPIRV-Tools-opt SPIRV-Tools-static FILE SPIRV-Tools.cmake)

if(WIN32 AND NOT MINGW)
    install(EXPORT SPIRV-Tools DESTINATION "${INSTALL_CMAKEDIR_ROOT}")
else()
    install(EXPORT SPIRV-Tools DESTINATION "${INSTALL_CMAKEDIR_ROOT}/SPIRV-Tools")
endif()

CPMAddPackage(
    NAME SPIRV-Cross
    GITHUB_REPOSITORY KhronosGroup/SPIRV-Cross
    GIT_TAG vulkan-sdk-1.4.304.1
    GIT_SHALLOW ON
    GIT_SUBMODULES_RECURSE OFF
    OPTIONS
        "SPIRV_CROSS_SHARED ${BUILD_SHARED_LIBS}"
        "SPIRV_CROSS_STATIC ${LSTGEXT_BUILD_STATIC_LIBS}"
        "SPIRV_CROSS_CLI OFF"
        "SPIRV_CROSS_ENABLE_TESTS OFF"
        "SPIRV_CROSS_ENABLE_CPP OFF"
        "SPIRV_CROSS_ENABLE_REFLECT OFF"
        "SPIRV_CROSS_ENABLE_C_API OFF"
)
if(BUILD_SHARED_LIBS)
    add_library(spirv_cross_c_shared ALIAS spirv-cross-c-shared)
else()
    add_library(spirv_cross_c ALIAS spirv-cross-c)
    add_library(spirv_cross_core ALIAS spirv-cross-core)
    add_library(spirv_cross_glsl ALIAS spirv-cross-glsl)
    add_library(spirv_cross_hlsl ALIAS spirv-cross-hlsl)
    add_library(spirv_cross_msl ALIAS spirv-cross-msl)
endif()

# directx shader compiler

CPMAddPackage(
    NAME DXC
    GITHUB_REPOSITORY microsoft/DirectXShaderCompiler
    GIT_TAG v1.8.2502
    GIT_SHALLOW ON
    GIT_SUBMODULES_RECURSE OFF
    # OPTIONS
    #     "BUILD_SHARED_LIBS OFF"
    #     "HLSL_ENABLE_DEBUG_ITERATORS ON"
    #     "DXC_COVERAGE OFF"
    #     "HLSL_INCLUDE_TESTS OFF"
    #     "LLVM_INCLUDE_TESTS OFF"
    #     "HLSL_DISABLE_SOURCE_GENERATION TRUE"
    #     "ENABLE_SPIRV_CODEGEN ON"
    DOWNLOAD_ONLY YES
    PATCHES "DXShader.patch"
)

set(_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})

set(BUILD_SHARED_LIBS OFF)
set(HLSL_ENABLE_DEBUG_ITERATORS ON)
set(DXC_COVERAGE OFF)
set(HLSL_INCLUDE_TESTS OFF)
set(LLVM_INCLUDE_TESTS OFF)
set(HLSL_DISABLE_SOURCE_GENERATION TRUE)
set(ENABLE_SPIRV_CODEGEN ON)

include(${DXC_SOURCE_DIR}/cmake/caches/PredefinedParams.cmake)
add_subdirectory(${DXC_SOURCE_DIR} EXCLUDE_FROM_ALL)

set(BUILD_SHARED_LIBS ${_BUILD_SHARED_LIBS})

install(TARGETS dxcompiler dxildll EXPORT DirectXShaderCompiler)
export(TARGETS dxcompiler dxildll FILE DirectXShaderCompiler.cmake)

if(WIN32 AND NOT MINGW)
    install(EXPORT DirectXShaderCompiler DESTINATION "${INSTALL_CMAKEDIR_ROOT}")
else()
    install(EXPORT DirectXShaderCompiler DESTINATION "${INSTALL_CMAKEDIR_ROOT}/DirectXShaderCompiler")
endif()


# sdl_shadercross

CPMAddPackage(
    NAME SDL_shadercross
    GITHUB_REPOSITORY libsdl-org/SDL_shadercross
    GIT_TAG 63026450dedbf7d8aeee99d9086719f425b2bb4d
    GIT_SUBMODULES_RECURSE OFF
    OPTIONS
        "SDLSHADERCROSS_INSTALL ON"
        "SDLSHADERCROSS_DXC ON"
        "SDLSHADERCROSS_SPIRVCROSS_SHARED ${BUILD_SHARED_LIBS}"
        "SDLSHADERCROSS_SHARED ${BUILD_SHARED_LIBS}"
        "SDLSHADERCROSS_STATIC ${LSTGEXT_BUILD_STATIC_LIBS}"
        "SDLSHADERCROSS_VENDORED OFF"
    PATCHES "SDL_shadercross.patch"
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
    GIT_SHALLOW ON
    GIT_SUBMODULES_RECURSE OFF
    OPTIONS
        "BUILD_EXTERNAL OFF"
        "ENABLE_GLSLANG_JS OFF"
        "ENABLE_HLSL OFF" # use dxc instead
        "ENABLE_SPVREMAPPER OFF"
        "GLSLANG_ENABLE_INSTALL ON"
)
