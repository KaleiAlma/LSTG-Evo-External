# sdl2

CPMAddPackage(
    NAME SDL2
    GITHUB_REPOSITORY libsdl-org/SDL
    GIT_TAG release-2.30.10
)
luastg_external_target_common_options(SDL2)
luastg_external_target_common_options(SDL2main)

# g-truc glm
# OpenGL math library

CPMAddPackage(
    NAME glm
    GITHUB_REPOSITORY g-truc/glm
    GIT_TAG 1.0.1
    OPTIONS
    "GLM_ENABLE_CXX_17 ON"
)
luastg_external_target_common_options(glm)

# tinygltf
# Parser for gltf 2.0 files

CPMAddPackage(
    NAME tinygltf
    VERSION 2.8.14
    GITHUB_REPOSITORY syoyo/tinygltf
    #OPTIONS
    #"TINYGLTF_BUILD_LOADER_EXAMPLE OFF"
    #"TINYGLTF_INSTALL OFF"
    DOWNLOAD_ONLY YES
)

if(tinygltf_ADDED)
    # tinygltf's CMake support kinda sucks, so we do it ourself.
    add_library(tinygltf STATIC)
    luastg_external_target_common_options(tinygltf)
    target_compile_definitions(tinygltf PUBLIC
        TINYGLTF_NO_STB_IMAGE_WRITE
    )
    # In order to avoid using its own JSON and stb libs,
    # you must first pull the header file to a separate folder
    file(WRITE ${CMAKE_BINARY_DIR}/tinygltf/tiny_gltf.h "PLACEHOLD")
    file(REMOVE
        ${CMAKE_BINARY_DIR}/tinygltf/tiny_gltf.h
    )
    file(COPY_FILE
        ${tinygltf_SOURCE_DIR}/tiny_gltf.h
        ${CMAKE_BINARY_DIR}/tinygltf/tiny_gltf.h
    )
    # Configure include path to avoid using its own JSON and stb libs
    target_include_directories(tinygltf PUBLIC
        ${CMAKE_BINARY_DIR}/tinygltf
        ${nlohmann_json_SOURCE_DIR}/include/nlohmann # Very stupid
    )
    target_sources(tinygltf PRIVATE
        ${CMAKE_BINARY_DIR}/tinygltf/tiny_gltf.h
        ${tinygltf_SOURCE_DIR}/tiny_gltf.cc
    )
    target_link_libraries(tinygltf PRIVATE
        nlohmann_json
        nothings_stb
    )
    set_target_properties(tinygltf PROPERTIES FOLDER external)
endif()

# # tinyobjloader
# # Parser for OBJ files

# CPMAddPackage(
#     NAME tinyobjloader
#     #VERSION 2.0.0
#     GITHUB_REPOSITORY tinyobjloader/tinyobjloader
#     GIT_TAG v2.0.0rc10
#     DOWNLOAD_ONLY YES
# )

# if(tinyobjloader_ADDED)
#     # tinyobjloader's CMake support kinda sucks, so we do it ourself.
#     add_library(tinyobjloader STATIC)
#     target_include_directories(tinyobjloader PUBLIC
#         ${tinyobjloader_SOURCE_DIR}
#     )
#     target_sources(tinyobjloader PRIVATE
#         ${tinyobjloader_SOURCE_DIR}/tiny_obj_loader.h
#         ${tinyobjloader_SOURCE_DIR}/tiny_obj_loader.cc
#     )
#     set_target_properties(tinyobjloader PROPERTIES FOLDER external)
# endif()

# freetype
# Font utilities

CPMAddPackage(
    NAME freetype
    VERSION 2.13.1
    #GITHUB_REPOSITORY freetype/freetype
    #GIT_TAG VER-2-13-1
    URL https://gitlab.freedesktop.org/freetype/freetype/-/archive/VER-2-13-1/freetype-VER-2-13-1.zip
    OPTIONS
    "FT_DISABLE_ZLIB ON"
    "FT_DISABLE_BZIP2 ON"
    "FT_DISABLE_PNG ON"
    "FT_DISABLE_HARFBUZZ ON"
    "FT_DISABLE_BROTLI ON"
)

if(freetype_ADDED)
    if(TARGET freetype)
        luastg_external_target_common_options(freetype)
        if(MSVC)
            target_compile_options(freetype PRIVATE
                "/utf-8" # Unicode warning
            )
        endif()
        set_target_properties(freetype PROPERTIES FOLDER external)
    endif()
endif()

