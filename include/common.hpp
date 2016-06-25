#ifndef GREENTEA_COMMON_HPP_
#define GREENTEA_COMMON_HPP_

#include <iostream>
#include <type_traits>
#include <sstream>
#include <iomanip>
#include "version.hpp"

#ifndef GREENTEA_QUEUE_COUNT
#define GREENTEA_QUEUE_COUNT 1
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




enum Backend {
  BACKEND_CPU,
  BACKEND_CUDA,
  BACKEND_OpenCL
};


}

#endif  // GREENTEA_COMMON_HPP_
