#ifndef GREENTEA_DEVICE_HPP_
#define GREENTEA_DEVICE_HPP_

#include <string>
#include <vector>

#include "common.hpp"


using std::vector;

namespace greentea {

class device {
 public:
  explicit device();
  explicit device(int id, int list_id, Backend backend);
  Backend backend() const;
  int id() const;
  int list_id() const;
  int current_queue_id();
  int workgroup_size(int id);

#ifdef USE_OPENCL
  static void setupViennaCLContext(int id,
                                   const cl_context ctx,
                                   const cl_device_id dev,
                                   const cl_command_queue queue);

  viennacl::ocl::program& program();
  void SetProgram();
  bool is_host_unified();
#endif  // USE_OPENCL

  int num_queues();
  void SwitchQueue(int id);
  void FinishQueues();

  void Init();

  uint_tp memory_usage();
  uint_tp peak_memory_usage();
  std::string name();
  void IncreaseMemoryUsage(uint_tp bytes);
  void DecreaseMemoryUsage(uint_tp bytes);
  void ResetPeakMemoryUsage();
  bool CheckCapability(std::string cap);
  bool CheckVendor(std::string vendor);
  bool CheckType(std::string type);

 private:
  int current_queue_id_;
  std::vector<int> workgroup_sizes_;
  int id_;
  int list_id_;
  Backend backend_;
  uint_tp memory_usage_;
  uint_tp peak_memory_usage_;
  bool host_unified_;
  std::string name_;
#ifdef USE_OPENCL
  viennacl::ocl::program ocl_program_;
#endif  // USE_OPENCL
};
}  // namespace greentea

#endif  // GREENTEA_DEVICE_HPP_
