
function(luastg_external_target_common_options_no_unicode __TARGET__)
    if(MSVC)
        target_compile_options(${__TARGET__} INTERFACE
            "/MP"
            "$<$<CONFIG:Debug>:/ZI>"
        )
        target_link_options(${__TARGET__} INTERFACE
            "/DEPENDENTLOADFLAG:0x800" # Windows 10 1607+ 强制 DLL 搜索目录为系统目录
        )
        if(CMAKE_SIZEOF_VOID_P EQUAL 4 AND TARGET_ARCHITECTURE EQUAL "x86_64")
            target_compile_options(${__TARGET__} INTERFACE
                "/arch:AVX"
            )
        endif()
    else()
        if(CMAKE_SIZEOF_VOID_P EQUAL 4 AND TARGET_ARCHITECTURE EQUAL "x86_64")
            target_compile_options(${__TARGET__} INTERFACE
                "-mavx"
            )
        endif()
    endif()

    set_target_properties(${__TARGET__} PROPERTIES
        C_STANDARD 17
        C_STANDARD_REQUIRED ON
        CXX_STANDARD 20
        CXX_STANDARD_REQUIRED ON
    )
    if(NOT WIN32)
        target_compile_definitions(${__TARGET__} INTERFACE
            _FILE_OFFSET_BITS=64
        )
    endif()
endfunction()

function(luastg_external_target_common_options __TARGET__)
    luastg_external_target_common_options_no_unicode(${__TARGET__})
    target_compile_definitions(${__TARGET__} INTERFACE
        _UNICODE
        UNICODE
    )
endfunction()
