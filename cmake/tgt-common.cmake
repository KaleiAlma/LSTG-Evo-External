
set(LSTG_EXTERNAL_COMPILE_OPTS "-march=${TARGET_ARCH_REV}")
set(LSTG_EXTERNAL_COMPILE_OPTS_WIN "/arch:${TARGET_ARCH_REV_WIN}")

if(MSVC)
    add_compile_options(
        "/MP"
        "$<$<CONFIG:Debug>:/ZI>"
    )
    add_link_options(
        # Windows 10 1607+ forces the DLL search directory to be the system directory
        "/DEPENDENTLOADFLAG:0x800"
    )
endif()

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(NOT WIN32)
    add_compile_definitions(
        _FILE_OFFSET_BITS=64
    )
endif()


if(MSVC)
    add_compile_options(${LSTG_EXTERNAL_COMPILE_OPTS_WIN})
else()
    add_compile_options(${LSTG_EXTERNAL_COMPILE_OPTS})
endif()


function(lstgext_tgtopts_unicode __TARGET__)
    target_compile_definitions(${__TARGET__} PUBLIC
        _UNICODE
        UNICODE
    )
endfunction()

function(lstgext_tgtopts_full __TARGET__)
    lstgext_tgtopts_unicode(${__TARGET__})
endfunction()
