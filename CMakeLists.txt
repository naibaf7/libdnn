cmake_minimum_required(VERSION 2.8.7)

# enables set VERSION in command `project`
if(POLICY CMP0048)
    cmake_policy(SET CMP0048 NEW)
endif()

# ---[ Greentea project
project(Greentea-LibDNN VERSION 0.1.0 LANGUAGES C CXX)

if(POLICY CMP0046)
  cmake_policy(SET CMP0046 NEW)
endif()

if(POLICY CMP0054)
  cmake_policy(SET CMP0054 NEW)
endif()

string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)
string(REPLACE "-" "_" PROJECT_NAME_UNDERSCORE ${PROJECT_NAME_LOWER})
string(REPLACE "-" ""  PROJECT_NAME_MERGE      ${PROJECT_NAME})

set(PROJECT_EXPORT_NAME         ${PROJECT_NAME_MERGE})
set(PROJECT_LIBRARY_TARGET_NAME ${PROJECT_NAME_UNDERSCORE})

set(INCLUDE_INSTALL_DIR include/greentea
    CACHE PATH "Install dir for headers")
set(PACKAGE_INSTALL_DIR share/${PROJECT_EXPORT_NAME}
    CACHE PATH "Install dir for cmake package config files")
set(LIB_INSTALL_DIR lib
    CACHE PATH "Install dir for shared libraries")

set(CMAKE_CONFIG_FILE         "${PROJECT_EXPORT_NAME}Config.cmake")
set(CMAKE_CONFIG_VERSION_FILE "${PROJECT_EXPORT_NAME}ConfigVersion.cmake")

set(CMAKE_TARGETS_NAME "${PROJECT_EXPORT_NAME}Targets")
set(CMAKE_TARGETS_FILE "${CMAKE_TARGETS_NAME}.cmake")

# ---[ Using cmake scripts and modules
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/Modules)

include(ExternalProject)

include(cmake/Utils.cmake)
include(cmake/Targets.cmake)
include(cmake/Misc.cmake)
include(cmake/Summary.cmake)
include(cmake/ConfigGen.cmake)

# ---[ Options
greentea_option(USE_INDEX_64 "Build Greentea LibDNN with 64 bit indexing" OFF)
greentea_option(USE_CUDA "Build Greentea LibDNN with CUDA support" ON)
greentea_option(USE_OPENCL "Build Greentea LibDNN with OpenCL support" ON)
greentea_option(BUILD_SHARED_LIBS "Build shared libraries" ON)

# ---[ Dependencies
include(cmake/Dependencies.cmake)

# ---[ Flags
if(UNIX OR APPLE)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -Wall -std=c++11 -DCMAKE_BUILD -Wno-unused-variable")
endif()

# TODO(naibaf7): Is it needed?
greentea_set_greentea_link()

if(USE_libstdcpp)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libstdc++ -std=c++11")
  message("-- Warning: forcing libstdc++ (controlled by USE_libstdcpp option in cmake)")
endif()

add_definitions(-DGTEST_USE_OWN_TR1_TUPLE)

# ---[ Warnings
greentea_warnings_disable(CMAKE_CXX_FLAGS -Wno-sign-compare -Wno-uninitialized)

# ---[ Config generation
configure_file(cmake/Templates/greentea_libdnn_config.h.in
        "${PROJECT_BINARY_DIR}/greentea_libdnn_config.h")

# ---[ Includes
set(GREENTEA_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include)
include_directories(${GREENTEA_INCLUDE_DIR} ${PROJECT_BINARY_DIR})
#include_directories(BEFORE src) # This is needed for gtest.

# ---[ Subdirectories
add_subdirectory(src)

# ---[ Configuration summary
greentea_print_configuration_summary()

# ---[ Export configs generation
# generate_export_configs()

include(CMakePackageConfigHelpers)
configure_package_config_file(
    "cmake/Templates/${CMAKE_CONFIG_FILE}.in"
    ${CMAKE_BINARY_DIR}/${CMAKE_CONFIG_FILE}
    PATH_VARS LIB_INSTALL_DIR INCLUDE_INSTALL_DIR
    INSTALL_DESTINATION ${PACKAGE_INSTALL_DIR}) 

write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CONFIG_VERSION_FILE}
    VERSION ${PROJECT_VERSION} 
    COMPATIBILITY SameMajorVersion)

# uninstall target
configure_file(
    "${PROJECT_SOURCE_DIR}/cmake/Templates/cmake-uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake-uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall COMMAND ${CMAKE_COMMAND}
    -P ${CMAKE_CURRENT_BINARY_DIR}/cmake-uninstall.cmake)

# ---[ Install and export package

install(EXPORT ${CMAKE_TARGETS_NAME}
        FILE   ${CMAKE_TARGETS_FILE}
        DESTINATION ${PACKAGE_INSTALL_DIR})

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CONFIG_FILE}
              ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CONFIG_VERSION_FILE}
        DESTINATION ${PACKAGE_INSTALL_DIR} COMPONENT share)
