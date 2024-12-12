cmake_minimum_required(VERSION 3.27)
project(LuaSTGEvo-External)

set(BUILD_TESTING OFF CACHE BOOL "" FORCE)

#==================================================#
# ==================== common ==================== #
#==================================================#

include(cmake/architecture.cmake)
target_architecture(TARGET_ARCHITECTURE)
message("== [ Compiling LuaSTG Evo dependencies for ${TARGET_ARCHITECTURE} architecture ] ==")
include(cmake/TargetCommonOptions.cmake)

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

# ==================== lua filesystem ====================

add_library(lua_filesystem STATIC)
luastg_external_target_common_options_no_unicode(lua_filesystem)
target_include_directories(lua_filesystem PUBLIC
    luafilesystem/src
)
target_sources(lua_filesystem PRIVATE
    luafilesystem/src/lfs.h
    luafilesystem/src/lfs.c
)
target_link_libraries(lua_filesystem PUBLIC
    luajit-static
)

set_target_properties(lua_filesystem PROPERTIES FOLDER lualib)

# ==================== lua cjson ====================

add_library(lua_cjson STATIC)
luastg_external_target_common_options(lua_cjson)
if(MSVC)
    target_compile_options(lua_cjson PRIVATE
        "/wd4090" # Different const qualifiers (pointer passing)
    )
endif()
target_compile_definitions(lua_cjson PRIVATE
    _CRT_SECURE_NO_WARNINGS
    DISABLE_INVALID_NUMBERS
    ENABLE_CJSON_GLOBAL
)
target_include_directories(lua_cjson PUBLIC
    lua-cjson-patch
)
target_include_directories(lua_cjson PRIVATE
    lua-cjson
)
target_sources(lua_cjson PRIVATE
    lua-cjson-patch/lua_cjson.h
    lua-cjson/lua_cjson.c
    lua-cjson/strbuf.h
    lua-cjson/strbuf.c
    lua-cjson/fpconv.h
    lua-cjson/fpconv.c
)
target_link_libraries(lua_cjson PUBLIC
    luajit-static
)

set_target_properties(lua_cjson PROPERTIES FOLDER lualib)

# ==================== lua csv ====================

#add_library(lua_xlsx_csv STATIC)
#luastg_external_target_common_options(lua_xlsx_csv)
#target_include_directories(lua_xlsx_csv PUBLIC
#    lua-csv
#)
#target_sources(lua_xlsx_csv PRIVATE
#    lua-csv/lua_xlsx_csv.h
#    lua-csv/lua_xlsx.cpp
#    lua-csv/lua_csv.cpp
#)
#target_link_libraries(lua_xlsx_csv PUBLIC
#    luajit
#    zip
#    pugixml
#)
#
#set_target_properties(lua_xlsx_csv PROPERTIES FOLDER external)

#====================================================#
# ==================== graphics ==================== #
#====================================================#

include(cmake/packages.gfx.cmake)

# ==================== glad ====================

add_library(glad STATIC)
luastg_external_target_common_options(glad)
target_include_directories(glad PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/glad/include)
target_sources(glad PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/glad/src/gl.c
)

#=================================================#
# ==================== imgui ==================== #
#=================================================#

add_library(imgui STATIC)
luastg_external_target_common_options(imgui)
target_compile_definitions(imgui PUBLIC
    IMGUI_DISABLE_OBSOLETE_FUNCTIONS
    IMGUI_DISABLE_OBSOLETE_KEYIO
    #IMGUI_USE_BGRA_PACKED_COLOR
    IMGUI_USE_WCHAR32
    IMGUI_ENABLE_FREETYPE
)
target_include_directories(imgui PUBLIC
    imgui/imgui
    imgui/imgui/misc/cpp
    imgui/imgui/misc/freetype
    # ${FREETYPE_INCLUDE_DIRS}
)
target_sources(imgui PRIVATE
    imgui/imgui/imstb_rectpack.h
    imgui/imgui/imstb_textedit.h
    imgui/imgui/imstb_truetype.h
    
    imgui/imgui/imconfig.h
    imgui/imgui/imgui_demo.cpp
    imgui/imgui/imgui_draw.cpp
    imgui/imgui/imgui_internal.h
    imgui/imgui/imgui_tables.cpp
    imgui/imgui/imgui_widgets.cpp
    imgui/imgui/imgui.cpp
    imgui/imgui/imgui.h
    
    imgui/imgui/misc/cpp/imgui_stdlib.cpp
    imgui/imgui/misc/cpp/imgui_stdlib.h
    
    imgui/imgui/misc/freetype/imgui_freetype.cpp
    imgui/imgui/misc/freetype/imgui_freetype.h
)
target_link_libraries(imgui PUBLIC
    freetype
)

set_target_properties(imgui PROPERTIES FOLDER external)

# implot

add_library(implot STATIC)
luastg_external_target_common_options(implot)
target_compile_definitions(implot PUBLIC
    IMPLOT_DISABLE_OBSOLETE_FUNCTIONS
)
target_include_directories(implot PUBLIC
    implot
)
target_sources(implot PUBLIC
    imgui/implot/implot_demo.cpp
    imgui/implot/implot_internal.h
    imgui/implot/implot_items.cpp
    imgui/implot/implot.cpp
    imgui/implot/implot.h
)
target_link_libraries(implot PUBLIC
    imgui
)

set_target_properties(implot PROPERTIES FOLDER external)

# imgui backend opengl3

add_library(imgui_impl_opengl3 STATIC)
luastg_external_target_common_options(imgui_impl_opengl3)
# target_include_directories(imgui_impl_opengl3 PUBLIC
#     imgui/backends
# )
target_sources(imgui_impl_opengl3 PRIVATE
    imgui/imgui/backends/imgui_impl_opengl3.h
    imgui/imgui/backends/imgui_impl_opengl3.cpp
    # backend/imgui_impl_opengl3.cpp
)
target_link_libraries(imgui_impl_opengl3 PUBLIC
    imgui
)
set_target_properties(imgui_impl_opengl3 PROPERTIES FOLDER external)

# imgui backend sdl2

add_library(imgui_impl_sdl2 STATIC)
luastg_external_target_common_options(imgui_impl_sdl2)
target_include_directories(imgui_impl_sdl2 PUBLIC
    # backend
    imgui/imgui/backends
    # ${SDL2_INCLUDE_DIR}
    # ${CMAKE_SOURCE_DIR}/external/sdl2/include/
)
target_sources(imgui_impl_sdl2 PRIVATE
    imgui/imgui/backends/imgui_impl_sdl2.cpp
    imgui/imgui/backends/imgui_impl_sdl2.h
)
target_link_libraries(imgui_impl_sdl2 PUBLIC
    imgui
    SDL2-static
)
set_target_properties(imgui_impl_sdl2 PROPERTIES FOLDER external)

# imgui lua binding

add_library(lua_imgui STATIC)
luastg_external_target_common_options(lua_imgui)
target_include_directories(lua_imgui PUBLIC
    imgui/binding/include
)
target_include_directories(lua_imgui PRIVATE
    imgui/binding/src
)
target_sources(lua_imgui PRIVATE
    imgui/binding/include/lua_imgui.hpp
    imgui/binding/include/lua_imgui_type.hpp
    
    imgui/binding/src/lua_imgui_common.hpp
    imgui/binding/src/lua_imgui_enum.hpp
    imgui/binding/src/lua_imgui_enum.cpp
    imgui/binding/src/lua_imgui_hash.cpp
    imgui/binding/src/lua_imgui_hash.hpp
    imgui/binding/src/lua_imgui_ImGui.hpp
    imgui/binding/src/lua_imgui_ImGui_ColorX.inl
    imgui/binding/src/lua_imgui_ImGui_DragX.inl
    imgui/binding/src/lua_imgui_ImGui_InputX.inl
    imgui/binding/src/lua_imgui_ImGui_PlotX.inl
    imgui/binding/src/lua_imgui_ImGui_register.inl
    imgui/binding/src/lua_imgui_ImGui_SliderX.inl
    imgui/binding/src/lua_imgui_ImGui.cpp
    imgui/binding/src/lua_imgui_ImGuiTextBuffer.cpp
    imgui/binding/src/lua_imgui_type.cpp
    imgui/binding/src/lua_imgui.cpp
)
target_link_libraries(lua_imgui PUBLIC
    imgui
    luajit-static
)

set_target_properties(lua_imgui PROPERTIES FOLDER lualib)


#=================================================#
# ==================== audio ==================== #
#=================================================#

include(cmake/packages.xiph.cmake)

add_library(miniaudio STATIC)
luastg_external_target_common_options(miniaudio)
target_include_directories(miniaudio PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/miniaudio/)
target_sources(miniaudio PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/miniaudio/miniaudio.c
)
target_link_libraries(miniaudio PUBLIC
    Ogg::ogg
    vorbis
    vorbisfile
)

#================================================#
# ==================== misc ==================== #
#================================================#

include(cmake/packages.cpm.cmake)
include(cmake/packages.z.cmake)

# ==================== xmath ====================

add_library(xmath STATIC)
luastg_external_target_common_options(xmath)
target_include_directories(xmath PUBLIC
    xmath-patch
    xmath
)
target_sources(xmath PRIVATE
    xmath-patch/math/Vec2.h
    xmath-patch/math/Vec2.cpp
    xmath/meow_fft.c
    xmath/meow_fft.h
    xmath/XCollision.cpp
    xmath/XCollision.h
    xmath/XComplex.cpp
    xmath/XComplex.h
    xmath/XConstant.h
    xmath/XDistance.cpp
    xmath/XDistance.h
    xmath/XEquation.cpp
    xmath/XEquation.h
    xmath/XFFT.cpp
    xmath/XFFT.h
    xmath/XIntersect.cpp
    xmath/XIntersect.h
    xmath/XMath.h
    xmath/XRandom.cpp
    xmath/XRandom.h
    xmath/XSpline.cpp
    xmath/XSpline.h
    xmath/XTween.cpp
    xmath/XTween.h
)

set_target_properties(xmath PROPERTIES FOLDER external)

# ==================== tracy ====================

option(ENABLE_TRACY_CLIENT "" OFF)

add_library(tracy STATIC)
luastg_external_target_common_options(tracy)
if(ENABLE_TRACY_CLIENT)
    target_compile_definitions(tracy PUBLIC
        TRACY_ENABLE
    )
endif()
target_include_directories(tracy PUBLIC
    tracy/public/tracy
)
target_sources(tracy PRIVATE
    tracy/public/tracy/Tracy.hpp
    tracy/public/tracy/TracyOpenGL.hpp
    tracy/public/TracyClient.cpp
)

set_target_properties(tracy PROPERTIES FOLDER external)

# ==================== steam api ====================

add_subdirectory(steam_api)

# ==================== ffmpeg ====================



#===========================================================#
# ==================== prebuild target ==================== #
#===========================================================#


set(ExternalLibs
    # lua
    luajit-static
    luasocket
    lua_filesystem
    lua_cjson
    toml.lua
    sol2
    lua_steam_api
    lua_imgui

    # graphics
    glad
    SDL2main
    SDL2-static
    SDL2
    glm
    tinygltf
    freetype

    # imgui
    imgui
    implot
    imgui_impl_opengl3
    imgui_impl_sdl2

    # audio
    miniaudio

    # misc
    xmath
    tracy
    nlohmann_json
    spdlog
    pugixml
    nothings_stb
    pcg_cpp
    xxhash
    uni-algo
    minizip
)

make_directory(${CMAKE_CURRENT_BINARY_DIR}/out)
set(EXTERNAL_OUTDIR ${CMAKE_CURRENT_BINARY_DIR}/out/external)

function(list_add_if_not_present list elem)
    list(FIND "${list}" "${elem}" exists)
    if(exists EQUAL -1)
        list(APPEND "${list}" "${elem}")
        set("${list}" "${${list}}" PARENT_SCOPE)
    endif()
endfunction()

function(get_dependency_list input_list output_list)
    list(APPEND ${output_list} ${${input_list}})

    foreach(dep ${${input_list}})
        if(NOT TARGET ${dep})
            continue()
        endif()

        get_target_property(subdeps ${dep} LINK_LIBRARIES)

        list(LENGTH subdeps len)
        if(("${subdeps}" MATCHES "subdeps-NOTFOUND"))
            continue()
        endif()

        get_dependency_list(subdeps ${output_list})
        list(APPEND ${output_list} ${subdeps})
    endforeach()
    set("${output_list}" "${${output_list}}" PARENT_SCOPE)

endfunction()

set(static_glob "lib*.a")
set(shared_glob "lib*.so")
if(WIN32)
    set(static_glob "*.lib")
    set(shared_glob "*.dll")
endif()

set(valid_binary_targets
    STATIC_LIBRARY
    SHARED_LIBRARY
)

# set(full_dep_list ${ExternalLibs})
get_dependency_list(ExternalLibs full_dep_list)
list(REMOVE_DUPLICATES full_dep_list)

foreach(dep ${full_dep_list})
    if(NOT TARGET ${dep})
        list(REMOVE_ITEM full_dep_list ${dep})
    endif()
endforeach()

set(bin_files)
set(include_dirs_map)
set(already_added)
foreach(dep ${full_dep_list})
    get_target_property(inc_dirs ${dep} INTERFACE_INCLUDE_DIRECTORIES)
    list(LENGTH inc_dirs len)
    if(NOT (len EQUAL 1 AND "${inc_dirs}" MATCHES "inc_dirs-NOTFOUND"))
        set(dir_list)
        foreach(dir ${inc_dirs})
            if("${dir}" MATCHES "\\\$")
                continue()
            endif()
            list(APPEND dir_list ${dir})
        endforeach()
        string(REPLACE "-static" "" final_incdir_name ${dep})
        string(REGEX REPLACE "^.*::" "" final_incdir_name ${final_incdir_name})

        list(FIND already_added "${dep}" exists)
        if(exists EQUAL -1)
            list(APPEND already_added "${dep}")
        else()
            continue()
        endif()

        # exceptions because they used generator expressions
        if(final_incdir_name MATCHES "SDL2")
            list(APPEND dir_list ${SDL2_BINARY_DIR}/include/SDL2 ${SDL2_BINARY_DIR}/include-config-release/SDL2)
        endif()
        if(final_incdir_name MATCHES "SDL2main")
            continue() # don't want to duplicate SDL2 includes
        endif()
        if(final_incdir_name MATCHES "sol2")
            list(APPEND dir_list ${sol2_SOURCE_DIR}/include/sol/)
        endif()
        if(final_incdir_name MATCHES "freetype")
            list(APPEND dir_list ${freetype_SOURCE_DIR}/include/freetype/ ${freetype_BINARY_DIR}/include/freetype/)
        endif()
        if(final_incdir_name MATCHES "glm-header-only")
            set(final_incdir_name "glm")
            list(APPEND dir_list ${glm_SOURCE_DIR}/glm/)
        endif()
        if(final_incdir_name MATCHES "ogg")
            list(APPEND dir_list ${libogg_SOURCE_DIR}/include/ogg/ ${libogg_BINARY_DIR}/include/ogg/)
        endif()
        if(final_incdir_name MATCHES "vorbis")
            list(APPEND dir_list ${libvorbis_SOURCE_DIR}/include/vorbis/)
        endif()
        if(final_incdir_name MATCHES "vorbisfile")
            continue() # same directories as vorbis
        endif()
        if(final_incdir_name MATCHES "tomlplusplus")
            list(APPEND dir_list ${tomlplusplus_SOURCE_DIR}/include/toml++/)
        endif()
        if(final_incdir_name MATCHES "nlohmann_json")
            list(APPEND dir_list ${nlohmann_json_SOURCE_DIR}/include/nlohmann/)
        endif()
        if(final_incdir_name MATCHES "spdlog")
            list(APPEND dir_list ${spdlog_SOURCE_DIR}/include/spdlog/)
        endif()
        if(final_incdir_name MATCHES "uni-algo")
            list(APPEND dir_list ${uni-algo_SOURCE_DIR}/include/uni_algo/)
        endif()
        if(final_incdir_name MATCHES "magic_enum")
            list(APPEND dir_list ${magic_enum_SOURCE_DIR}/include/magic_enum/)
        endif()
        if(final_incdir_name MATCHES "minizip")
            list(APPEND dir_list ${minizip_ng_SOURCE_DIR}/ ${minizip_ng_BINARY_DIR}/)
        endif()

        if(final_incdir_name MATCHES "imgui_impl")
            continue()
        endif()

        list(APPEND include_dirs_map [${final_incdir_name} [${dir_list}]])
    endif()


    get_target_property(dep_type ${dep} TYPE)

    if(dep_type IN_LIST valid_binary_targets)
        list(APPEND bin_files "$<TARGET_FILE:${dep}>")
    endif()
endforeach()

set(copy_header_commands)
foreach(entry ${include_dirs_map})
    string(LENGTH "${entry}" len)
    math(EXPR len "${len} - 2")
    string(SUBSTRING "${entry}" 1 ${len} entry)

    list(GET entry 0 dirname)
    list(GET entry 1 include_dirs)

    string(LENGTH "${include_dirs}" len)
    math(EXPR len "${len} - 2")
    string(SUBSTRING "${include_dirs}" 1 ${len} include_dirs)

    set(headers)
    set(rel)
    foreach(dir ${include_dirs})
        file(GLOB_RECURSE inc_h ${dir}/*.h)
        file(GLOB_RECURSE inc_hpp ${dir}/*.hpp)
        file(GLOB_RECURSE inc_hxx ${dir}/*.hxx)
        set(inc_inl)
        if(dirname MATCHES "glm")
            file(GLOB_RECURSE inc_inl ${dir}/*.inl) # glm
        endif()
        set(headers ${headers} ${inc_h} ${inc_hpp} ${inc_hxx} ${inc_inl})
        file(GLOB_RECURSE rel_h RELATIVE ${dir} ${dir}/*.h)
        file(GLOB_RECURSE rel_hpp RELATIVE ${dir} ${dir}/*.hpp)
        file(GLOB_RECURSE rel_hxx RELATIVE ${dir} ${dir}/*.hxx)
        set(rel_inl)
        if(dirname MATCHES "glm")
            file(GLOB_RECURSE rel_inl RELATIVE ${dir} ${dir}/*.inl) # glm
        endif()
        set(rel ${rel} ${rel_h} ${rel_hpp} ${rel_hxx} ${rel_inl})
    endforeach()

    list(APPEND copy_header_commands
        COMMAND ${CMAKE_COMMAND} -E make_directory ${EXTERNAL_OUTDIR}/include/${dirname}
        # COMMAND ${CMAKE_COMMAND} -E copy_if_different ${headers} ${EXTERNAL_OUTDIR}/include/${dirname}
    )
    set(subdirs ".")
    foreach(header r IN ZIP_LISTS headers rel)
        if(NOT (header MATCHES ${r}))
            message("== These files don't match up! ${header} ${r}")
        endif()
        string(REGEX REPLACE "[A-Za-z0-9_.-]+\\.(h[px]*|inl)$" "" subdir ${r})
        if(subdir)
            # list_add_if_not_present(subdirs ${subdir})

            list(FIND subdirs "${subdir}" exists)
            if(exists EQUAL -1)
                list(APPEND subdirs "${subdir}")
                list(APPEND copy_header_commands
                    COMMAND ${CMAKE_COMMAND} -E make_directory ${EXTERNAL_OUTDIR}/include/${dirname}/${subdir}
                )
            endif()
        endif()

        list(APPEND copy_header_commands
            COMMAND ${CMAKE_COMMAND} -E copy_if_different ${header} ${EXTERNAL_OUTDIR}/include/${dirname}/${r}
        )
    endforeach()
endforeach()

add_custom_target(ExternalZip
    DEPENDS ${ExternalLibs}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${EXTERNAL_OUTDIR}
    # COMMAND ${CMAKE_COMMAND} -E make_directory ${EXTERNAL_OUTDIR}/static
    # COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_BINARY_DIR}/${static_glob} ${EXTERNAL_OUTDIR}/static
    # COMMAND ${CMAKE_COMMAND} -E copy_if_different ${SDL2_BINARY_DIR}/${static_glob} ${EXTERNAL_OUTDIR}/static
    # COMMAND ${CMAKE_COMMAND} -E copy_if_different ${luajit_SOURCE_DIR}/src/${static_glob} ${EXTERNAL_OUTDIR}/static
    COMMAND ${CMAKE_COMMAND} -E make_directory ${EXTERNAL_OUTDIR}/libs
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${bin_files} ${EXTERNAL_OUTDIR}/libs

    # COMMAND ${CMAKE_COMMAND} -E make_directory ${EXTERNAL_OUTDIR}/shared
    # # COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_BINARY_DIR}/${shared_glob} ${EXTERNAL_OUTDIR}/shared
    # COMMAND ${CMAKE_COMMAND} -E copy_if_different ${SDL2_BINARY_DIR}/${shared_glob} ${EXTERNAL_OUTDIR}/shared
    # COMMAND ${CMAKE_COMMAND} -E copy_if_different ${luajit_SOURCE_DIR}/src/${shared_glob} ${EXTERNAL_OUTDIR}/shared
    COMMAND ${CMAKE_COMMAND} -E make_directory ${EXTERNAL_OUTDIR}/include
    ${copy_header_commands}

    COMMAND ${CMAKE_COMMAND} -E chdir ${EXTERNAL_OUTDIR}/..
        ${CMAKE_COMMAND} -E tar cfv ${CMAKE_CURRENT_BINARY_DIR}/external.zip --format=zip ${EXTERNAL_OUTDIR}
)

