# Check the host operating system type
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
  message(STATUS "Host OS is Linux")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
  message(STATUS "Host OS is macOS")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
  message(STATUS "Host OS is Windows")
else()
  message(STATUS "Host OS is unknown: ${CMAKE_HOST_SYSTEM_NAME}")
endif()

if(EXISTS $ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake)

  set(CMAKE_TOOLCHAIN_FILE $ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake)
  if(WIN32)
    set(VCPKG_PATH $ENV{VCPKG_ROOT}/vcpkg.exe)
  else()
    set(VCPKG_PATH $ENV{VCPKG_ROOT}/vcpkg)
  endif()

elseif(NOT DEFINED _WRAPPER_VCPKG_INCLUDE)
  set(_WRAPPER_VCPKG_INCLUDE "vcpkg included")
  include(FetchContent)
  set(FETCHCONTENT_QUIET FALSE)
  FetchContent_Declare(
    vcpkg
    GIT_REPOSITORY "https://github.com/microsoft/vcpkg.git"
    GIT_SHALLOW 1
    GIT_PROGRESS TRUE)

  message(
    STATUS
      "Fetching vcpkg as cmake submodule from https://github.com/microsoft/vcpkg.git"
  )
  FetchContent_MakeAvailable(vcpkg)
  message(STATUS "Fetched vcpkg")

  FetchContent_GetProperties("vcpkg" SOURCE_DIR vcpkg_SOURCE_DIR)

  # bootstrap vcpkg
  message(STATUS "Bootstrapping vcpkg")
  if(WIN32)
    if(NOT EXISTS "${vcpkg_SOURCE_DIR}/vcpkg.exe")
      execute_process(COMMAND cmd /c "${vcpkg_SOURCE_DIR}/bootstrap-vcpkg.bat"
                              COMMAND_ERROR_IS_FATAL ANY)
    endif(NOT EXISTS "${vcpkg_SOURCE_DIR}/vcpkg.exe")
    set(VCPKG_PATH
        "${vcpkg_SOURCE_DIR}/vcpkg.exe"
        CACHE STRING "vcpkg path" FORCE)
  else()
    if(NOT EXISTS "${vcpkg_SOURCE_DIR}/vcpkg")
      execute_process(COMMAND sh "${vcpkg_SOURCE_DIR}/bootstrap-vcpkg.sh"
                              COMMAND_ERROR_IS_FATAL ANY)
    endif(NOT EXISTS "${vcpkg_SOURCE_DIR}/vcpkg")
    set(VCPKG_PATH
        "${vcpkg_SOURCE_DIR}/vcpkg"
        CACHE STRING "vcpkg path" FORCE)
  endif()
  message(STATUS "Bootstrapped vcpkg")

  # include toolchain file
  message(STATUS "setting toolchain file to vcpkg.cmake")
  set(CMAKE_TOOLCHAIN_FILE ${vcpkg_SOURCE_DIR}/scripts/buildsystems/vcpkg.cmake)

endif()

function(vcpkg_create_manifest)
  if(VCPKG_MANIFEST_CREATED)
    message(STATUS "Found existing vcpkg manifest")
    return()
  endif(VCPKG_MANIFEST_CREATED)

  set(options)
  set(oneValueArgs NAME VERSION DIR INSTALL_DIR)
  set(multiValueArgs)
  cmake_parse_arguments("MANIFEST" "${options}" "${oneValueArgs}"
                        "${multiValueArgs}" ${ARGN})

  if(EXISTS "${MANIFEST_DIR}/vcpkg.json")
    message(STATUS "Manifest file already created")
    set(VCPKG_MANIFEST_DIR
        ${MANIFEST_DIR}
        CACHE STRING "manifest dir" FORCE)
    return()
  endif(EXISTS "${MANIFEST_DIR}/vcpkg.json")

  execute_process(
    COMMAND "${VCPKG_PATH}" "new" "--name" "${MANIFEST_NAME}" "--version"
            "${MANIFEST_VERSION}" "--x-install-root=${MANIFEST_INSTALL_DIR}"
    WORKING_DIRECTORY "${MANIFEST_DIR}" COMMAND_ERROR_IS_FATAL ANY)
  execute_process(
    COMMAND "${VCPKG_PATH}" "x-update-baseline" "--add-initial-baseline"
    WORKING_DIRECTORY "${MANIFEST_DIR}")
  set(VCPKG_MANIFEST_CREATED
      true
      CACHE BOOL "whether vcpkg is found" FORCE)
  set(VCPKG_MANIFEST_DIR
      ${MANIFEST_DIR}
      CACHE STRING "manifest dir" FORCE)
endfunction(vcpkg_create_manifest)

function(vcpkg_add)
  if(NOT EXISTS "${VCPKG_MANIFEST_DIR}/vcpkg.json")
    message(
      FATAL_ERROR
        "ERROR: vcpkg manifest not found, expected: ${VCPKG_MANIFEST_DIR}/vcpkg.json"
    )
    return()
  endif(NOT EXISTS "${VCPKG_MANIFEST_DIR}/vcpkg.json")

  set(options)
  set(oneValueArgs NAME)
  set(multiValueArgs)
  cmake_parse_arguments("PACKAGE" "${options}" "${oneValueArgs}"
                        "${multiValueArgs}" ${ARGN})
  execute_process(
    COMMAND "${VCPKG_PATH}" "add" "port" "${PACKAGE_NAME}"
    WORKING_DIRECTORY "${VCPKG_MANIFEST_DIR}" COMMAND_ERROR_IS_FATAL ANY)
endfunction(vcpkg_add)

function(vcpkg_install)
  if(NOT VCPKG_FOUND)
    message(FATAL_ERROR "ERROR: vcpkg is not found")
    return()
  endif(NOT VCPKG_FOUND)

  set(options)
  set(oneValueArgs TRIPLET)
  set(multiValueArgs)
  cmake_parse_arguments("INSTALL" "${options}" "${oneValueArgs}"
                        "${multiValueArgs}" ${ARGN})

  execute_process(
    COMMAND "${VCPKG_PATH}" "install" "--triplet=${INSTALL_TRIPLET}"
            "--clean-after-build" WORKING_DIRECTORY "${VCPKG_MANIFEST_DIR}"
                                                    COMMAND_ERROR_IS_FATAL ANY)
endfunction(vcpkg_install)

function(vcpkg_import_sdk)
  set(options)
  set(oneValueArgs URL HASH NAME)
  set(multiValueArgs)
  cmake_parse_arguments("SDK" "${options}" "${oneValueArgs}"
                        "${multiValueArgs}" ${ARGN})

  FetchContent_Declare(
    "${SDK_NAME}"
    URL "${SDK_URL}"
    URL_HASH "${SDK_HASH}")

  message(STATUS "Fetching SDK artifact ${SDK_NAME} from ${SDK_URL}")
  FetchContent_MakeAvailable("${SDK_NAME}")
  message(STATUS "Fetched SDK artifact ${SDK_NAME} from ${SDK_URL}")

  FetchContent_GetProperties("${SDK_NAME}" SOURCE_DIR SDK_SOURCE_DIR)

  message(STATUS "SDK ${SDK_NAME} source dir: ${SDK_SOURCE_DIR}")

  include("${SDK_SOURCE_DIR}/scripts/buildsystems/vcpkg.cmake")
endfunction(vcpkg_import_sdk)

# function(vcpkg_create_symlink)
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${VCPKG_PATH}
                        ${CMAKE_BINARY_DIR}/vcpkg)
# endfunction()
