/* =========================================================================
   Copyright (c) 2010-2016, Institute for Microelectronics,
                            Institute for Analysis and Scientific Computing,
                            TU Wien.
   Portions of this software are copyright by UChicago Argonne, LLC.

                            -----------------
                  ViennaCL - The Vienna Computing Library
                            -----------------

   Project Head:    Karl Rupp                   rupp@iue.tuwien.ac.at

   (A list of authors and contributors can be found in the PDF manual)

   License:         MIT (X11), see file LICENSE in the base directory
============================================================================= */

/** \file tests/src/matrix_row_float.cpp  Tests routines for dense matrices, row-major, single precision.
*   \test Tests routines for dense matrices, row-major, single precision.
**/


#include "matrix_float_double.hpp"

int main (int, const char **)
{
  std::cout << std::endl;
  std::cout << "----------------------------------------------" << std::endl;
  std::cout << "----------------------------------------------" << std::endl;
  std::cout << "## Test :: Matrix operations, row-major, single precision " << std::endl;
  std::cout << "----------------------------------------------" << std::endl;
  std::cout << "----------------------------------------------" << std::endl;
  std::cout << std::endl;

  double epsilon = 1e-4;
  std::cout << "# Testing setup:" << std::endl;
  std::cout << "  eps:     " << epsilon << std::endl;
  std::cout << "  numeric: float" << std::endl;
  std::cout << " --- row-major ---" << std::endl;
  if (run_test<viennacl::row_major, float>(epsilon) != EXIT_SUCCESS)
    return EXIT_FAILURE;

  std::cout << std::endl;
  std::cout << "------- Test completed --------" << std::endl;
  std::cout << std::endl;

  return EXIT_SUCCESS;
}

