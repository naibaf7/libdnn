#ifndef GREENTEA_COMMON_HPP_
#define GREENTEA_COMMON_HPP_

#include <iostream>
#include <type_traits>
#include <sstream>
#include <iomanip>

#include "greentea_libdnn_config.h"

// #define LIBDNN_DEBUG 1
// #define VIENNACL_DEBUG_ALL 1

#ifdef USE_OPENCL
#define VIENNACL_PROFILING_ENABLED
#include "viennacl/backend/opencl.hpp"
#include "viennacl/ocl/backend.hpp"
#include "viennacl/ocl/context.hpp"
#include "viennacl/ocl/device.hpp"
#include "viennacl/ocl/platform.hpp"
#endif  // USE_OPENCL

#ifdef USE_CUDA
#include "cuda.h"
#include "nvrtc.h"
#include <cuda_runtime.h>
#include <curand.h>
#include <driver_types.h>
#endif  // USE_CUDA

#ifndef GREENTEA_QUEUE_COUNT
#define GREENTEA_QUEUE_COUNT 1
#endif

#ifndef CUDA_NUM_THREADS
#define CUDA_NUM_THREADS 1
#endif

#ifdef USE_OPENCL
#ifndef VIENNACL_WITH_OPENCL
#define VIENNACL_WITH_OPENCL
#endif  // VIENNACL_WITH_OPENCL
#endif  // USE_OPENCL

#ifdef USE_INDEX_64
#define int_tp int64_t
#define uint_tp uint64_t
#else
#define int_tp int32_t
#define uint_tp uint32_t
#endif

namespace greentea {

#ifdef USE_OPENCL
viennacl::ocl::handle<cl_mem> WrapHandle(cl_mem in,
                                         viennacl::ocl::context *ctx);
#endif

enum Backend {
  BACKEND_CPU,
  BACKEND_CUDA,
  BACKEND_OpenCL
};

template<typename T, typename U>
struct is_same {
  static const bool value = false;
};

template<typename T>
struct is_same<T, T> {
  static const bool value = true;
};

}

#endif  // GREENTEA_COMMON_HPP_
