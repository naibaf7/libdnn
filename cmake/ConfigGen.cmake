
################################################################################################
# Helper function to fetch greentea includes which will be passed to dependent projects
# Usage:
#   greentea_get_current_includes(<includes_list_variable>)
function(greentea_get_current_includes includes_variable)
  get_property(current_includes DIRECTORY PROPERTY INCLUDE_DIRECTORIES)
  greentea_convert_absolute_paths(current_includes)

  # remove at most one ${PROJECT_BINARY_DIR} include added for greentea_config.h
  list(FIND current_includes ${PROJECT_BINARY_DIR} __index)
  list(REMOVE_AT current_includes ${__index})

  # removing numpy includes (since not required for client libs)
  set(__toremove "")
  foreach(__i ${current_includes})
    if(${__i} MATCHES "python")
      list(APPEND __toremove ${__i})
    endif()
  endforeach()
  if(__toremove)
    list(REMOVE_ITEM current_includes ${__toremove})
  endif()

  greentea_list_unique(current_includes)
  set(${includes_variable} ${current_includes} PARENT_SCOPE)
endfunction()

################################################################################################
# Helper function to get all list items that begin with given prefix
# Usage:
#   greentea_get_items_with_prefix(<prefix> <list_variable> <output_variable>)
function(greentea_get_items_with_prefix prefix list_variable output_variable)
  set(__result "")
  foreach(__e ${${list_variable}})
    if(__e MATCHES "^${prefix}.*")
      list(APPEND __result ${__e})
    endif()
  endforeach()
  set(${output_variable} ${__result} PARENT_SCOPE)
endfunction()

################################################################################################
# Function for generation Greentea build- and install- tree export config files
# Usage:
#  generate_export_configs()
function(generate_export_configs)
  set(install_cmake_suffix "share/Greentea")

  # ---[ Configure build-tree GreenteaConfig.cmake file ]---
  greentea_get_current_includes(GREENTEA_INCLUDE_DIRS)

  set(Greentea_DEFINITIONS "")
  if(NOT HAVE_OPENCL)
    set(HAVE_OPENCL FALSE)
  endif()
  
  if(NOT HAVE_CUDA)
    set(HAVE_CUDA FALSE)
  endif()

  configure_file("cmake/Templates/GreenteaLibDNNConfig.cmake.in" "${PROJECT_BINARY_DIR}/GreenteaConfig.cmake" @ONLY)

  # Add targets to the build-tree export set
  export(TARGETS greentea_libdnn FILE "${PROJECT_BINARY_DIR}/GreenteaLibDNNTargets.cmake")
  export(PACKAGE Greentea)

  # ---[ Configure install-tree GreenteaConfig.cmake file ]---

  # remove source and build dir includes
  greentea_get_items_with_prefix(${PROJECT_SOURCE_DIR} GREENTEA_INCLUDE_DIRS __insource)
  greentea_get_items_with_prefix(${PROJECT_BINARY_DIR} GREENTEA_INCLUDE_DIRS __inbinary)
  list(REMOVE_ITEM GREENTEA_INCLUDE_DIRS ${__insource} ${__inbinary})

  # add `install` include folder
  set(lines
     "get_filename_component(__greentea_include \"\${Greentea_CMAKE_DIR}/../../include\" ABSOLUTE)\n"
     "list(APPEND GREENTEA_INCLUDE_DIRS \${__greentea_include})\n"
     "unset(__greentea_include)\n")
  string(REPLACE ";" "" GREENTEA_INSTALL_INCLUDE_DIR_APPEND_COMMAND ${lines})

  configure_file("cmake/Templates/GreenteaLibDNNConfig.cmake.in" "${PROJECT_BINARY_DIR}/cmake/GreenteaLibDNNConfig.cmake" @ONLY)

  # Install the GreenteaConfig.cmake and export set to use with install-tree
  install(FILES "${PROJECT_BINARY_DIR}/cmake/GreenteaLibDNNConfig.cmake" DESTINATION ${install_cmake_suffix})
  install(EXPORT GreenteaLibDNNTargets DESTINATION ${install_cmake_suffix})

  # ---[ Configure and install version file ]---

  # TODO: Lines below are commented because Greentea does't declare its version in headers.
  # When the declarations are added, modify `greentea_extract_greentea_version()` macro and uncomment

  # configure_file(cmake/Templates/GreenteaConfigVersion.cmake.in "${PROJECT_BINARY_DIR}/GreenteaConfigVersion.cmake" @ONLY)
  # install(FILES "${PROJECT_BINARY_DIR}/GreenteaConfigVersion.cmake" DESTINATION ${install_cmake_suffix})
endfunction()


