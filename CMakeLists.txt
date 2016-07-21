cmake_minimum_required(VERSION 2.8.7)
if(POLICY CMP0046)
  cmake_policy(SET CMP0046 NEW)
endif()
if(POLICY CMP0054)
  cmake_policy(SET CMP0054 NEW)
endif()

# ---[ Greentea project
project(Greentea-LibDNN C CXX)

set(GREENTEA_TARGET_VERSION "0.1.0" CACHE STRING "Greentea logical version")
set(GREENTEA_TARGET_SOVERSION "0.1.0" CACHE STRING "Greentea soname version")

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
include_directories(BEFORE src) # This is needed for gtest.

# ---[ Subdirectories
add_subdirectory(src)

# ---[ Configuration summary
greentea_print_configuration_summary()

# ---[ Export configs generation
generate_export_configs()
