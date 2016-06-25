################################################################################################
# Defines global GREENTEA_LINK flag, This flag is required to prevent linker from excluding
# some objects which are not addressed directly but are registered via static constructors
macro(greentea_set_greentea_link)
  if(BUILD_SHARED_LIBS)
    set(GREENTEA_LINK greentea_libdnn)
  else()
    if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
      set(GREENTEA_LINK -Wl,-force_load greentea_libdnn)
    elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
      set(GREENTEA_LINK -Wl,--whole-archive greentea_libdnn -Wl,--no-whole-archive)
    endif()
  endif()
endmacro()
################################################################################################
# Convenient command to setup source group for IDEs that support this feature (VS, XCode)
# Usage:
#   greentea_source_group(<group> GLOB[_RECURSE] <globbing_expression>)
function(greentea_source_group group)
  cmake_parse_arguments(GREENTEA_SOURCE_GROUP "" "" "GLOB;GLOB_RECURSE" ${ARGN})
  if(GREENTEA_SOURCE_GROUP_GLOB)
    file(GLOB srcs1 ${GREENTEA_SOURCE_GROUP_GLOB})
    source_group(${group} FILES ${srcs1})
  endif()

  if(GREENTEA_SOURCE_GROUP_GLOB_RECURSE)
    file(GLOB_RECURSE srcs2 ${GREENTEA_SOURCE_GROUP_GLOB_RECURSE})
    source_group(${group} FILES ${srcs2})
  endif()
endfunction()

################################################################################################
# Collecting sources from globbing and appending to output list variable
# Usage:
#   greentea_collect_sources(<output_variable> GLOB[_RECURSE] <globbing_expression>)
function(greentea_collect_sources variable)
  cmake_parse_arguments(GREENTEA_COLLECT_SOURCES "" "" "GLOB;GLOB_RECURSE" ${ARGN})
  if(GREENTEA_COLLECT_SOURCES_GLOB)
    file(GLOB srcs1 ${GREENTEA_COLLECT_SOURCES_GLOB})
    set(${variable} ${variable} ${srcs1})
  endif()

  if(GREENTEA_COLLECT_SOURCES_GLOB_RECURSE)
    file(GLOB_RECURSE srcs2 ${GREENTEA_COLLECT_SOURCES_GLOB_RECURSE})
    set(${variable} ${variable} ${srcs2})
  endif()
endfunction()

################################################################################################
# Short command getting greentea sources (assuming standard Greentea code tree)
# Usage:
#   greentea_pickup_greentea_sources(<root>)
function(greentea_pickup_greentea_sources root)
  # put all files in source groups (visible as subfolder in many IDEs)
  greentea_source_group("Include"        GLOB "${root}/include/*.h*")
  greentea_source_group("Include"        GLOB "${PROJECT_BINARY_DIR}/greentea_config.h*")
  greentea_source_group("Source"         GLOB "${root}/src/*.cpp")


  # collect files
  file(GLOB_RECURSE hdrs ${root}/include/*.h*)
  file(GLOB_RECURSE srcs ${root}/src/*.cpp)

  # adding headers to make the visible in some IDEs (Qt, VS, Xcode)
  list(APPEND srcs ${hdrs} ${PROJECT_BINARY_DIR}/greentea_libdnn_config.h)
  list(APPEND test_srcs ${test_hdrs})
  
  # convert to absolute paths
  greentea_convert_absolute_paths(srcs)

  # propogate to parent scope
  set(srcs ${srcs} PARENT_SCOPE)
endfunction()

################################################################################################
# Short command for setting defeault target properties
# Usage:
#   greentea_default_properties(<target>)
function(greentea_default_properties target)
  set_target_properties(${target} PROPERTIES
    DEBUG_POSTFIX ${GREENTEA_DEBUG_POSTFIX}
    ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib"
    LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib"
    RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
  # make sure we build all external depepdencies first
  if (DEFINED external_project_dependencies)
    add_dependencies(${target} ${external_project_dependencies})
  endif()
endfunction()

################################################################################################
# Short command for setting runtime directory for build target
# Usage:
#   greentea_set_runtime_directory(<target> <dir>)
function(greentea_set_runtime_directory target dir)
  set_target_properties(${target} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${dir}")
endfunction()

################################################################################################
# Short command for setting solution folder property for target
# Usage:
#   greentea_set_solution_folder(<target> <folder>)
function(greentea_set_solution_folder target folder)
  if(USE_PROJECT_FOLDERS)
    set_target_properties(${target} PROPERTIES FOLDER "${folder}")
  endif()
endfunction()

################################################################################################
# Reads lines from input file, prepends source directory to each line and writes to output file
# Usage:
#   greentea_configure_testdatafile(<testdatafile>)
function(greentea_configure_testdatafile file)
  file(STRINGS ${file} __lines)
  set(result "")
  foreach(line ${__lines})
    set(result "${result}${PROJECT_SOURCE_DIR}/${line}\n")
  endforeach()
  file(WRITE ${file}.gen.cmake ${result})
endfunction()

