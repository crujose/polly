# Copyright (c) 2015, Tomas Zemaitis
# All rights reserved.

if(DEFINED POLLY_IOS_TOOLCHAIN_CMAKE_)
  return()
else()
  set(POLLY_IOS_TOOLCHAIN_CMAKE_ 1)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_clear_environment_variables.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

set(POLLY_IOS_NOCODESIGN FALSE CACHE BOOL "Skip code-signing only build for iphonesimulator if true.")
set(CMAKE_CXX_STANDARD "14" CACHE STRING "C++ language standard.")
set(IOS_SDK_VERSION 10.0 CACHE STRING "Target SDK version")

set(POLLY_XCODE_COMPILER "clang")
polly_init(
    "iOS ${IOS_SDK_VERSION} / ${POLLY_XCODE_COMPILER} / c++11 support"
    "Xcode"
)

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")

include(polly_fatal_error)

# Fix try_compile
set(MACOSX_BUNDLE_GUI_IDENTIFIER com.example)
set(CMAKE_MACOSX_BUNDLE YES)

if (POLLY_IOS_NOCODESIGN)
    # Verify XCODE_XCCONFIG_FILE
    set(
        _polly_xcode_xcconfig_file_path
        "${CMAKE_CURRENT_LIST_DIR}/scripts/NoCodeSign.xcconfig"
    )
    if(NOT EXISTS "$ENV{XCODE_XCCONFIG_FILE}")
      polly_fatal_error(
          "Path specified by XCODE_XCCONFIG_FILE environment variable not found"
          "($ENV{XCODE_XCCONFIG_FILE})"
          "Use this command to set: "
          "    export XCODE_XCCONFIG_FILE=${_polly_xcode_xcconfig_file_path}"
      )
    else()
      string(
          COMPARE
          NOTEQUAL
          "$ENV{XCODE_XCCONFIG_FILE}"
          "${_polly_xcode_xcconfig_file_path}"
          _polly_wrong_xcconfig_path
      )
      if(_polly_wrong_xcconfig_path)
        polly_fatal_error(
            "Unexpected XCODE_XCCONFIG_FILE value: "
            "    $ENV{XCODE_XCCONFIG_FILE}"
            "expected: "
            "    ${_polly_xcode_xcconfig_file_path}"
        )
      endif()
    endif()
else()
    set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer")
    set(IPHONEOS_ARCHS armv7;armv7s;arm64)
endif()
set(IPHONESIMULATOR_ARCHS i386;x86_64)

include("${CMAKE_CURRENT_LIST_DIR}/compiler/xcode.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/os/iphone.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/flags/cxx11.cmake")

if (IOS_SDK_VERSION VERSION_GREATER 10.0 OR IOS_SDK_VERSION VERSION_EQUAL 10.0)
    include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_ios_development_team.cmake")
endif()
