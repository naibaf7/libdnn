# This list is required for static linking and exported to GreenteaLibDNNConfig.cmake
set(GREENTEA_LINKER_LIBS "")

# ---[ CUDA
include(cmake/Cuda.cmake)
if(NOT HAVE_CUDA)
  if(NOT USE_CUDA)
    message(STATUS "-- CUDA is disabled. Building without it...")
  else()
    set(USE_CUDA OFF)
    message(WARNING "-- CUDA is not detected by cmake. Building without it...")
  endif()
endif()

# ---[ OpenCL & ViennaCL
if(USE_OPENCL)
  find_package(OpenCL QUIET)
  if(NOT HAVE_OPENCL)
    message(FATAL_ERROR "OpenCL required for OpenCL but not found.")
  endif()
  find_package(ViennaCL)
  if(NOT HAVE_VIENNACL)
    message(FATAL_ERROR "ViennaCL required for OpenCL but not found.")
  endif()
  include_directories(SYSTEM ${VIENNACL_INCLUDE_DIRS})
  list(APPEND GREENTEA_LINKER_LIBS ${VIENNACL_LIBRARIES})
  set(VIENNACL_WITH_OPENCL ${VIENNACL_WITH_OPENCL})
endif()
