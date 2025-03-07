cmake_minimum_required(VERSION 3.27)
project(LuaSTGEvo-External)

set(BUILD_TESTING OFF CACHE BOOL "" FORCE)

#==================================================#
# ==================== common ==================== #
#==================================================#

set(DEFAULT_x86_64_REVISION "westmere" CACHE STRING "Clang x86_64 CPU revision")
set(DEFAULT_x86_64_REVISION_WINDOWS "SSE4.2" CACHE STRING "MSVC x64 architecture flag")
set(DEFAULT_ARM64_REVISION "armv8.2-a" CACHE STRING "Clang ARM64 CPU revision")
set(DEFAULT_ARM64_REVISION_WINDOWS "armv8.2" CACHE STRING "MSVC ARM64 architecture flag")

include(cmake/architecture.cmake)
target_architecture(TARGET_ARCHITECTURE)
if(NOT DEFINED TARGET_ARCH_REV)
    if(TARGET_ARCHITECTURE STREQUAL "x86_64")
        set(TARGET_ARCH_REV ${DEFAULT_x86_64_REVISION})
    elseif(TARGET_ARCHITECTURE STREQUAL "aarch64")
        set(TARGET_ARCH_REV ${DEFAULT_ARM64_REVISION})
    endif()
endif()
if(NOT DEFINED TARGET_ARCH_REV_WIN)
    if(TARGET_ARCHITECTURE STREQUAL "x86_64")
        set(TARGET_ARCH_REV_WIN ${DEFAULT_x86_64_REVISION_WINDOWS})
    elseif(TARGET_ARCHITECTURE STREQUAL "aarch64")
        set(TARGET_ARCH_REV_WIN ${DEFAULT_ARM64_REVISION_WINDOWS})
    endif()
endif()

set(LSTG_x86_64 OFF)
set(LSTG_SSE4_2 OFF)
set(LSTG_AVX OFF)
set(LSTG_AVX2 OFF)
set(LSTG_AVX512F OFF)
set(LSTG_ARM64 OFF)

if(TARGET_ARCHITECTURE STREQUAL "x86_64")
    set(LSTG_x86_64 ON)
    if(TARGET_ARCH_REV_WIN STREQUAL "SSE4.2")
        set(LSTG_SSE4_2 ON)
    endif()
    if(TARGET_ARCH_REV_WIN MATCHES "AVX")
        set(LSTG_SSE4_2 ON)
        set(LSTG_AVX ON)
        if(TARGET_ARCH_REV_WIN STREQUAL "AVX2")
            set(LSTG_AVX2 ON)
        endif()
        if(TARGET_ARCH_REV_WIN STREQUAL "AVX512")
            set(LSTG_AVX2 ON)
            set(LSTG_AVX512F ON)
        endif()
    endif()
elseif(TARGET_ARCHITECTURE STREQUAL "aarch64")
    set(LSTG_ARM64 ON)
endif()

message("== [ Compiling LuaSTG Evo dependencies for ${TARGET_ARCHITECTURE} (${TARGET_ARCH_REV}/${TARGET_ARCH_REV_WIN}) architecture ] ==")
include(cmake/tgt-common.cmake)

set(CMAKE_SKIP_INSTALL_ALL_DEPENDENCY TRUE)
set(SKIP_INSTALL_ALL FALSE)
set(SKIP_INSTALL_LIBRARIES FALSE)
option(LSTG_EXTERNAL_INSTALL_SUBDIR lstgext)
set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/${LSTG_EXTERNAL_INSTALL_SUBDIR})
set(LSTG_EXTERNAL_SOURCES)
set(LSTG_EXTERNAL_HEADERS)
set(LSTG_EXTERNAL_DEFINES)
set(LSTG_EXTERNAL_INCDIRS)

set(LSTG_IMGUI_HEADERS)
set(LSTG_IMGUI_BASEDIRS)
set(LSTG_PCG_HEADERS)
set(LSTG_PCG_BASEDIRS)
set(LSTG_STB_HEADERS)
set(LSTG_STB_BASEDIRS)


# ==================== cpm ====================

set(CPM_DOWNLOAD_VERSION 0.40.0)

if(CPM_SOURCE_CACHE)
    set(CPM_DOWNLOAD_LOCATION "${CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
elseif(DEFINED ENV{CPM_SOURCE_CACHE})
    set(CPM_DOWNLOAD_LOCATION "$ENV{CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
else()
    set(CPM_DOWNLOAD_LOCATION "${CMAKE_BINARY_DIR}/cmake/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
endif()

if(NOT(EXISTS ${CPM_DOWNLOAD_LOCATION}))
    message(STATUS "Downloading CPM.cmake to ${CPM_DOWNLOAD_LOCATION}")
    file(DOWNLOAD
        https://github.com/cpm-cmake/CPM.cmake/releases/download/v${CPM_DOWNLOAD_VERSION}/CPM.cmake
        ${CPM_DOWNLOAD_LOCATION}
    )
endif()

include(${CPM_DOWNLOAD_LOCATION})


#===============================================#
# ==================== lua ==================== #
#===============================================#

include(cmake/packages.lua.cmake)


#====================================================#
# ==================== graphics ==================== #
#====================================================#

include(cmake/packages.gfx.cmake)


#=================================================#
# ==================== imgui ==================== #
#=================================================#


list(APPEND LSTG_IMGUI_BASEDIRS
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui
)

list(APPEND LSTG_EXTERNAL_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/imstb_textedit.h
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/imstb_truetype.h

    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imconfig.h
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/imgui_demo.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/imgui_draw.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/imgui_internal.h
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/imgui_tables.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/imgui_widgets.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/imgui.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/imgui.h

    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/misc/cpp/imgui_stdlib.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/misc/cpp/imgui_stdlib.h
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui_freetype.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/misc/freetype/imgui_freetype.h

    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/backends/imgui_impl_sdl3.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/backends/imgui_impl_sdl3.h
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/backends/imgui_impl_sdlgpu3.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/backends/imgui_impl_sdlgpu3.h
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/backends/imgui_impl_sdlgpu3_shaders.h
)


list(APPEND LSTG_IMGUI_HEADERS
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/imgui.h
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/misc/freetype/imgui_freetype.h
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/misc/cpp/imgui_stdlib.h
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/backends/imgui_impl_sdl3.h
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/imgui/backends/imgui_impl_sdlgpu3.h
)


# implot

list(APPEND LSTG_EXTERNAL_DEFINES
    IMPLOT_DISABLE_OBSOLETE_FUNCTIONS
)

list(APPEND LSTG_IMGUI_BASEDIRS
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/implot
)

list(APPEND LSTG_IMGUI_HEADERS
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/implot/implot_demo.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/implot/implot_internal.h
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/implot/implot_items.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/implot/implot.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/implot/implot.h
)


# imgui lua binding

list(APPEND LSTG_IMGUI_BASEDIRS
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/include
)

list(APPEND LSTG_EXTERNAL_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/include/lua_imgui.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/include/lua_imgui_type.hpp

    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_common.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_enum.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_enum.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_hash.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_hash.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_ImGui.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_ImGui_ColorX.inl
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_ImGui_DragX.inl
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_ImGui_InputX.inl
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_ImGui_PlotX.inl
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_ImGui_register.inl
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_ImGui_SliderX.inl
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_ImGui.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_ImGuiTextBuffer.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui_type.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/src/lua_imgui.cpp
)
# target_link_libraries(lua_imgui
#     PUBLIC imgui luajit-static
# )

# set_target_properties(lua_imgui PROPERTIES FOLDER lualib)

list(APPEND LSTG_IMGUI_HEADERS
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/include/lua_imgui.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/imgui/binding/include/lua_imgui_type.hpp
)


#=================================================#
# ==================== audio ==================== #
#=================================================#


list(APPEND LSTG_EXTERNAL_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/miniaudio/miniaudio.h)
list(APPEND LSTG_EXTERNAL_HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/miniaudio/miniaudio.h)
list(APPEND LSTG_EXTERNAL_INCDIRS ${CMAKE_CURRENT_SOURCE_DIR}/miniaudio)
list(APPEND LSTG_EXTERNAL_DEFINES MA_IMPLEMENTATION MA_USE_STDINT)


#================================================#
# ==================== misc ==================== #
#================================================#

include(cmake/packages.cpm.cmake)
include(cmake/packages.z.cmake)


# ==================== xmath ====================

list(APPEND LSTG_EXTERNAL_INCDIRS
    ${CMAKE_CURRENT_SOURCE_DIR}/xmath/xmath
    ${CMAKE_CURRENT_SOURCE_DIR}/xmath/xmath-patch
)
list(APPEND LSTG_EXTERNAL_SOURCES
    xmath/xmath-patch/math/Vec2.h
    xmath/xmath-patch/math/Vec2.cpp
    xmath/xmath/meow_fft.c
    xmath/xmath/meow_fft.h
    xmath/xmath/XCollision.cpp
    xmath/xmath/XCollision.h
    xmath/xmath/XComplex.cpp
    xmath/xmath/XComplex.h
    xmath/xmath/XConstant.h
    xmath/xmath/XDistance.cpp
    xmath/xmath/XDistance.h
    xmath/xmath/XEquation.cpp
    xmath/xmath/XEquation.h
    xmath/xmath/XFFT.cpp
    xmath/xmath/XFFT.h
    xmath/xmath/XIntersect.cpp
    xmath/xmath/XIntersect.h
    xmath/xmath/XMath.h
    xmath/xmath/XRandom.cpp
    xmath/xmath/XRandom.h
    xmath/xmath/XSpline.cpp
    xmath/xmath/XSpline.h
    xmath/xmath/XTween.cpp
    xmath/xmath/XTween.h
)


#===========================================================#
# ==================== prebuild target ==================== #
#===========================================================#

set(ExternalLibs
    luajit-static
    sol2

    SDL3::SDL3
    glm
    freetype

    xmath
    TracyClient
    nlohmann_json
    spdlog
    uni-algo
    minizip
)

add_library(lstgext STATIC ${LSTG_EXTERNAL_SOURCES})
lstgext_tgtopts_full(lstgext)
target_compile_definitions(lstgext PUBLIC ${LSTG_EXTERNAL_DEFINES})

target_sources(lstgext INTERFACE
    FILE_SET public_header TYPE HEADERS
        BASE_DIRS ${LSTG_EXTERNAL_INCDIRS}
        FILES ${LSTG_EXTERNAL_HEADERS}
    FILE_SET imgui_header TYPE HEADERS
        BASE_DIRS ${LSTG_IMGUI_BASEDIRS}
        FILES ${LSTG_IMGUI_HEADERS}
    FILE_SET pcg_header TYPE HEADERS
        BASE_DIRS ${LSTG_PCG_BASEDIRS}
        FILES ${LSTG_PCG_HEADERS}
    FILE_SET stb_header TYPE HEADERS
        BASE_DIRS ${LSTG_STB_BASEDIRS}
        FILES ${LSTG_STB_HEADERS}
)

set(LSTG_EXTERNAL_INCDIRS_FULL ${LSTG_EXTERNAL_INCDIRS}
    ${LSTG_IMGUI_BASEDIRS}
    ${LSTG_PCG_BASEDIRS}
    ${LSTG_STB_BASEDIRS}
)
target_include_directories(lstgext PUBLIC
    ${LSTG_EXTERNAL_INCDIRS_FULL}
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

target_link_libraries(lstgext PUBLIC ${ExternalLibs})

add_custom_target(external-build
    DEPENDS ${ExternalLibs} lstgext
)

install(TARGETS lstgext
    FILE_SET public_header
    FILE_SET imgui_header DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/imgui
    FILE_SET pcg_header DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/pcg
    FILE_SET stb_header DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/stb
)

add_custom_target(zip-install
    DEPENDS external-build install
    COMMAND ${CMAKE_COMMAND} -E tar cfv ${CMAKE_BINARY_DIR}/lstgext.zip --format=zip ${CMAKE_BINARY_DIR}/lstgext
)
