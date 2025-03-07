function(create_manifest_file_if_not_found)
  if(EXISTS "${CMAKE_SOURCE_DIR}/vcpkg.json")
    message(STATUS "Manifest file already created")
    set(VCPKG_MANIFEST_DIR
        ${CMAKE_SOURCE_DIR}
        CACHE STRING "manifest dir" FORCE)
    return()
  endif()

  message(STATUS "Creating vcpkg.json")
  if(DEFINED ENV{PACKAGE_NAME} AND DEFINED ENV{PACKAGE_VERSION})
    execute_process(
      COMMAND "${VCPKG_PATH}" "new" "--name" "$ENV{PACKAGE_NAME}" "--version" "$ENV{PACKAGE_VERSION}" 
      WORKING_DIRECTORY "${MANIFEST_DIR}" COMMAND_ERROR_IS_FATAL ANY)
  else()
    execute_process(
      COMMAND "${VCPKG_PATH}" "new" "--application"
      WORKING_DIRECTORY "${MANIFEST_DIR}" COMMAND_ERROR_IS_FATAL ANY)
  endif()
  execute_process(
    COMMAND "${VCPKG_PATH}" "x-update-baseline" "--add-initial-baseline"
    WORKING_DIRECTORY "${MANIFEST_DIR}")
  execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${VCPKG_PATH}
                          ${CMAKE_BINARY_DIR}/vcpkg)
endfunction()

if(DEFINED EXPORT_SDK_PATH
   AND EXISTS ${EXPORT_SDK_PATH}/scripts/buildsystems/vcpkg.cmake)
  message(STATUS "using an exported vcpkg sdk from ${EXPORT_SDK_PATH}")
  set(CMAKE_TOOLCHAIN_FILE ${EXPORT_SDK_PATH}/scripts/buildsystems/vcpkg.cmake)

elseif(EXISTS $ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake)
  message(STATUS "using vcpkg installed in $ENV{VCPKG_ROOT}")
  if(WIN32)
    set(VCPKG_PATH $ENV{VCPKG_ROOT}/vcpkg.exe)
  else()
    set(VCPKG_PATH $ENV{VCPKG_ROOT}/vcpkg)
  endif()
  create_manifest_file_if_not_found()
  set(CMAKE_TOOLCHAIN_FILE $ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake)

elseif(NOT DEFINED _WRAPPER_VCPKG_INCLUDE)
  set(_WRAPPER_VCPKG_INCLUDE "vcpkg included") # include guard
  message(STATUS "vcpkg not found on system, installing as build dependency")
  include(FetchContent)
  set(FETCHCONTENT_QUIET FALSE)
  set(_actual_tag master)
  if(DEFINED VCPKG_TAG)
    set(_actual_tag ${VCPKG_TAG})
  endif()
  FetchContent_Declare(
    vcpkg
    GIT_REPOSITORY "https://github.com/microsoft/vcpkg.git"
    GIT_TAG ${_actual_tag}
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

  create_manifest_file_if_not_found()
  # include toolchain file
  message(STATUS "setting toolchain file to vcpkg.cmake")
  set(CMAKE_TOOLCHAIN_FILE ${vcpkg_SOURCE_DIR}/scripts/buildsystems/vcpkg.cmake)

  set($ENV{VCPKG_ROOT} ${vcpkg_SOURCE_DIR}) # note: this only affect this CMake
                                            # run, not the invoking process

  configure_file(${CMAKE_CURRENT_LIST_DIR}/vcpkg_completion.bash.in
                 ${CMAKE_BINARY_DIR}/_vcpkg_env.bash @ONLY)
  configure_file(${CMAKE_CURRENT_LIST_DIR}/vcpkg_completion.zsh.in
                 ${CMAKE_BINARY_DIR}/_vcpkg_env.zsh @ONLY)
  message(
    STATUS
      "To use vcpkg from the command line, run the following command corresponding to your shell: "
  )
  message(STATUS "\n    source ${CMAKE_BINARY_DIR}/_vcpkg_env.bash\n")
  message(STATUS "\n    source ${CMAKE_BINARY_DIR}/_vcpkg_env.zsh\n")

endif()
