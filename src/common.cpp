#include "common.hpp"

namespace greentea {

#ifdef USE_OPENCL

viennacl::ocl::handle<cl_mem> WrapHandle(cl_mem in,
                                         viennacl::ocl::context *ctx) {
  if (in != nullptr) {
    // Valid cl_mem object, wrap to ViennaCL and return handle.
    viennacl::ocl::handle<cl_mem> memhandle(in, *ctx);
    memhandle.inc();
    return memhandle;
  } else {
    // Trick to pass nullptr via ViennaCL into OpenCL kernels.
    viennacl::ocl::handle<cl_mem> memhandle;
    return memhandle;
  }
}

#endif


}  // namespace greentea
