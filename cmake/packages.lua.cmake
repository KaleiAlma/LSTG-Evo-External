# luajit

CPMAddPackage(
    NAME luajit
    GITHUB_REPOSITORY KaleiAlma/LuaJIT-Evo
    GIT_TAG d8c9b65eaa16249383ea8af5ac96ba2bb0050d97
)


# sol2
# Lua C++ utility library

CPMAddPackage(
    NAME sol2
    GITHUB_REPOSITORY ThePhD/sol2
    VERSION 3.3.0
    OPTIONS
        "SOL2_LUA_VERSION LuaJIT"
)

list(APPEND LSTG_EXTERNAL_ALL_INCDIRS ${sol2_SOURCE_DIR}/include/sol)
