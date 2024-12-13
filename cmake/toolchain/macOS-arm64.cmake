
set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE INTERNAL "")

execute_process(
    COMMAND brew --prefix llvm@18
    OUTPUT_VARIABLE LLVM_DIR
)

set(CMAKE_C_COMPILER ${LLVM_DIR}/bin/clang)
set(CMAKE_C_COMPILER_TARGET aarch64-apple-darwin)
set(CMAKE_CXX_COMPILER ${LLVM_DIR}/bin/clang++)
set(CMAKE_CXX_COMPILER_TARGET aarch64-apple-darwin)
