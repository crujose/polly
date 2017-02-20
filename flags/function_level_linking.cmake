if(DEFINED POLLY_FLAGS_FUNCTION_LEVEL_LINKING_CMAKE)
  return()
else()
  set(POLLY_FLAGS_FUNCTION_LEVEL_LINKING_CMAKE 1)
endif()

include(polly_add_cache_flag)

polly_add_cache_flag(CMAKE_CXX_FLAGS_INIT "-ffunction-sections")
polly_add_cache_flag(CMAKE_CXX_FLAGS_INIT "-fdata-sections")
polly_add_cache_flag(CMAKE_C_FLAGS_INIT "-ffunction-sections")
polly_add_cache_flag(CMAKE_C_FLAGS_INIT "-fdata-sections")
polly_add_cache_flag(CMAKE_C_FLAGS_INIT "-ffunction-sections")

polly_add_cache_flag(CMAKE_SHARED_LINKER_FLAGS "-Wl,--gc-sections")
polly_add_cache_flag(CMAKE_MODULE_LINKER_FLAGS "-Wl,--gc-sections")
polly_add_cache_flag(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections")


list(APPEND HUNTER_TOOLCHAIN_UNDETECTABLE_ID "function-sections")
list(APPEND HUNTER_TOOLCHAIN_UNDETECTABLE_ID "data-sections")
list(APPEND HUNTER_TOOLCHAIN_UNDETECTABLE_ID "gc-sections")
