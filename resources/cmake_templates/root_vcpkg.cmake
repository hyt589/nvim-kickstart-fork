cmake_minimum_required(VERSION 3.20)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

# this file sets the CMAKE_TOOLCHAIN_FILE to the vcpkg one. it should be
# included instead of being set as CMAKE_TOOLCHAIN_FILE to avoid redownloading
# vcpkg when cmake performs toolchain checks
include(vcpkg.toolchain)

# TODO: Change project name
project(slang-test VERSION 1.0)

# Set output directories for all targets
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin) # Executables
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib) # Shared libraries
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib) # Static libraries

# Set per configuration output directories (Debug/Release)
foreach(CONFIG ${CMAKE_CONFIGURATION_TYPES})
  string(TOUPPER ${CONFIG} CONFIG_UPPER)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${CONFIG_UPPER}
      ${CMAKE_BINARY_DIR}/bin/${CONFIG})
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${CONFIG_UPPER}
      ${CMAKE_BINARY_DIR}/lib/${CONFIG})
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${CONFIG_UPPER}
      ${CMAKE_BINARY_DIR}/lib/${CONFIG})
endforeach()

add_library(${PROJECT_NAME}_interface INTERFACE)
target_include_directories(
  ${PROJECT_NAME}_interface
  INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>)

add_subdirectory(src)
