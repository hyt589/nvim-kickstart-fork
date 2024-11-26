cmake_minimum_required(VERSION 3.20)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

include(vcpkg.toolchain)

# TODO: Change project name
project(projectname VERSION 1.0)

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

set(${PROJECT_NAME}_PUBLIC_INCLUDE_DIR ${CMAKE_CURRENT_LIST_DIR}/include)

vcpkg_create_manifest(
  NAME
  ${PROJECT_NAME} # Name of your project
  VERSION
  ${CMAKE_PROJECT_VERSION} # Version of your project
  DIR
  ${CMAKE_CURRENT_LIST_DIR} # Directory in which to create the manifest file
  INSTALL_DIR
  ${CMAKE_CURRENT_BINARY_DIR}/vcpkg_installed) # Where packages will be
                                               # installed

add_subdirectory(src)
