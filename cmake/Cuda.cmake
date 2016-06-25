if(NOT USE_CUDA)
  return()
endif()

find_package(CUDA 7.5 QUIET)
find_cuda_helper_libs(curand)  # cmake 2.8.7 compartibility which doesn't search for curand

if(NOT CUDA_FOUND)
  return()
endif()

set(HAVE_CUDA TRUE)
message(STATUS "CUDA detected: " ${CUDA_VERSION})
include_directories(SYSTEM ${CUDA_INCLUDE_DIRS})
list(APPEND GREENTEA_LINKER_LIBS ${CUDA_CUDART_LIBRARY}
                              ${CUDA_curand_LIBRARY} ${CUDA_CUBLAS_LIBRARIES})

mark_as_advanced(CUDA_BUILD_CUBIN CUDA_BUILD_EMULATION CUDA_VERBOSE_BUILD)
mark_as_advanced(CUDA_SDK_ROOT_DIR CUDA_SEPARABLE_COMPILATION)

# Handle clang/libc++ issue
if(APPLE)
  greentea_detect_darwin_version(OSX_VERSION)

  # OSX 10.9 and higher uses clang/libc++ by default which is incompartible with old CUDA toolkits
  if(OSX_VERSION VERSION_GREATER 10.8)
    # enabled by default if and only if CUDA version is less than 7.0
    greentea_option(USE_libstdcpp "Use libstdc++ instead of libc++" (CUDA_VERSION VERSION_LESS 7.0))
  endif()
endif()
