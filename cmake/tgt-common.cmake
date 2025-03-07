
set(LSTG_EXTERNAL_COMPILE_OPTS "-march=${TARGET_ARCH_REV}")
set(LSTG_EXTERNAL_COMPILE_OPTS_WIN "/arch:${TARGET_ARCH_REV_WIN}")

function(lstgext_tgtopts_base __TARGET__)
    if(MSVC)
        target_compile_options(${__TARGET__} PUBLIC
            "/MP"
            "$<$<CONFIG:Debug>:/ZI>"
        )
        target_link_options(${__TARGET__} PUBLIC
            # Windows 10 1607+ forces the DLL search directory to be the system directory
            "/DEPENDENTLOADFLAG:0x800"
        )
    endif()

    set_target_properties(${__TARGET__} PROPERTIES
        C_STANDARD 17
        C_STANDARD_REQUIRED ON
        CXX_STANDARD 20
        CXX_STANDARD_REQUIRED ON
    )
    if(NOT WIN32)
        target_compile_definitions(${__TARGET__} PUBLIC
            _FILE_OFFSET_BITS=64
        )
    endif()
endfunction()

function(lstgext_tgtopts_arch_flag __TARGET__)
    if(MSVC)
        target_compile_options(${__TARGET__} PUBLIC
            ${LSTG_EXTERNAL_COMPILE_OPTS_WIN}
        )
    else()
        target_compile_options(${__TARGET__} PUBLIC
            ${LSTG_EXTERNAL_COMPILE_OPTS}
        )
    endif()
endfunction()

function(lstgext_tgtopts_unicode __TARGET__)
    target_compile_definitions(${__TARGET__} PUBLIC
        _UNICODE
        UNICODE
    )
endfunction()

function(lstgext_tgtopts_full __TARGET__)
    lstgext_tgtopts_base(${__TARGET__})
    lstgext_tgtopts_arch_flag(${__TARGET__})
    lstgext_tgtopts_unicode(${__TARGET__})
endfunction()
