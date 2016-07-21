#ifndef GREENTEA_BENCHMARK_HPP_
#define GREENTEA_BENCHMARK_HPP_

#include <chrono>
#include "common.hpp"
#include "device.hpp"

namespace greentea {

class Timer {
 public:
  Timer(device* dev_ptr);
  virtual ~Timer();
  virtual void Start();
  virtual void Stop();
  virtual float MilliSeconds();
  virtual float MicroSeconds();
  virtual float Seconds();

  inline bool initted() { return initted_; }
  inline bool running() { return running_; }
  inline bool has_run_at_least_once() { return has_run_at_least_once_; }

 protected:
  void Init();

  device* dev_ptr_;
  bool initted_;
  bool running_;
  bool has_run_at_least_once_;
#ifdef USE_CUDA
  cudaEvent_t start_gpu_cuda_;
  cudaEvent_t stop_gpu_cuda_;
#endif  // USE_CUDA
#ifdef USE_OPENCL
  cl_event start_gpu_cl_;
  cl_event stop_gpu_cl_;
#endif  // USE_OPENCL
  std::chrono::time_point<std::chrono::high_resolution_clock> start_cpu_;
  std::chrono::time_point<std::chrono::high_resolution_clock> stop_cpu_;
  float elapsed_milliseconds_;
  float elapsed_microseconds_;
};

class CPUTimer : public Timer {
 public:
  explicit CPUTimer(device* dev_ptr);
  virtual ~CPUTimer() {}
  virtual void Start();
  virtual void Stop();
  virtual float MilliSeconds();
  virtual float MicroSeconds();
};

}  // namespace greentea

#endif  // GREENTEA_BENCHMARK_HPP_
