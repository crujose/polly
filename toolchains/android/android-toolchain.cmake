if(DEFINED POLLY_ANDROID_TOOLCHAIN_)
  return()
else()
  set(POLLY_ANDROID_TOOLCHAIN_ 1)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_clear_environment_variables.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

set(CMAKE_SYSTEM_VERSION "19" CACHE STRING "Android API level.")
set(CMAKE_ANDROID_ARCH_ABI "armeabi-v7a" CACHE STRING "Target Android architecture. One of arm64-v8a, armeabi-v7a, armeabi-v6, armeabi, mips, mips64, x86, x86_64")
set(CMAKE_ANDROID_ARM_NEON FALSE CACHE BOOL "Only applies when CMAKE_ANDROID_ARCH_ABI is armeabi-v7a.  If TRUE target arm neon devices.")
set(CMAKE_ANDROID_ARM_MODE TRUE CACHE BOOL "If TRUE target 32bit arm (-marm), else target 16bit thumb -mthumb")
set(CMAKE_ANDROID_NDK_TOOLCHAIN_VERSION "4.9" CACHE STRING "<major>.<minor> for GCC toolchains.  clang or clang<major>.<minor> for clang toolchains.")
set(CMAKE_ANDROID_STL_TYPE "gnustl_static" CACHE STRING "STL variant to use.")
set(CMAKE_CXX_STANDARD "14" CACHE STRING "C++ language standard.")
set(POLLY_VISIBILITY_HIDDEN TRUE CACHE BOOL "Use -fvisibility=hidden")
set(POLLY_FUNCTION_LEVEL_LINKING TRUE CACHE BOOL "Put each function in separate section and allow garbage collection")
set(POLLY_ANDROID_VISUAL_STUDIO FALSE CACHE BOOL "Use Visual Studio generator.")

set(_polly_toolchain_name "Android NDK / API ${CMAKE_SYSTEM_VERSION} / ${CMAKE_ANDROID_ARCH_ABI}")
set(_polly_generator "Unix Makefiles")

if(POLLY_ANDROID_VISUAL_STUDIO)
    set(_polly_generator "Visual Studio 14 2015")
    if (CMAKE_ANDROID_ARCH_ABI MATCHES "^arm")
        string(APPEND _polly_generator " ARM")
    endif()
endif()

if (CMAKE_ANDROID_ARM_MODE)
    string(APPEND _polly_toolchain_name " / 32-bit ARM")
    if (CMAKE_ANDROID_ARM_NEON)
        string(APPEND _polly_toolchain_name " with NEON")
    endif()
endif()
if (POLLY_VISIBILITY_HIDDEN)
    string(APPEND _polly_toolchain_name " / visibility hidden")
endif()
if (POLLY_FUNCTION_LEVEL_LINKING)
    string(APPEND _polly_toolchain_name " / function-level linking")
endif()

polly_init(
    ${_polly_toolchain_name}
    "Unix Makefiles"
)

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")

if (POLLY_USE_CXX11)
    include("${CMAKE_CURRENT_LIST_DIR}/flags/cxx11.cmake") # before toolchain!
endif()
if (POLLY_VISIBILITY_HIDDEN)
    include("${CMAKE_CURRENT_LIST_DIR}/flags/hidden.cmake")
endif()
if (POLLY_FUNCTION_LEVEL_LINKING)
    include("${CMAKE_CURRENT_LIST_DIR}/flags/function_level_linking.cmake")
endif()


include("${CMAKE_CURRENT_LIST_DIR}/os/android.cmake")
