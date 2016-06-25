################################################################################################
# Greentea status report function.
# Automatically align right column and selects text based on condition.

function(greentea_status text)
  set(status_cond)
  set(status_then)
  set(status_else)

  set(status_current_name "cond")
  foreach(arg ${ARGN})
    if(arg STREQUAL "THEN")
      set(status_current_name "then")
    elseif(arg STREQUAL "ELSE")
      set(status_current_name "else")
    else()
      list(APPEND status_${status_current_name} ${arg})
    endif()
  endforeach()

  if(DEFINED status_cond)
    set(status_placeholder_length 23)
    string(RANDOM LENGTH ${status_placeholder_length} ALPHABET " " status_placeholder)
    string(LENGTH "${text}" status_text_length)
    if(status_text_length LESS status_placeholder_length)
      string(SUBSTRING "${text}${status_placeholder}" 0 ${status_placeholder_length} status_text)
    elseif(DEFINED status_then OR DEFINED status_else)
      message(STATUS "${text}")
      set(status_text "${status_placeholder}")
    else()
      set(status_text "${text}")
    endif()

    if(DEFINED status_then OR DEFINED status_else)
      if(${status_cond})
        string(REPLACE ";" " " status_then "${status_then}")
        string(REGEX REPLACE "^[ \t]+" "" status_then "${status_then}")
        message(STATUS "${status_text} ${status_then}")
      else()
        string(REPLACE ";" " " status_else "${status_else}")
        string(REGEX REPLACE "^[ \t]+" "" status_else "${status_else}")
        message(STATUS "${status_text} ${status_else}")
      endif()
    else()
      string(REPLACE ";" " " status_cond "${status_cond}")
      string(REGEX REPLACE "^[ \t]+" "" status_cond "${status_cond}")
      message(STATUS "${status_text} ${status_cond}")
    endif()
  else()
    message(STATUS "${text}")
  endif()
endfunction()


################################################################################################
# Function for fetching Greentea LibDNN version from git and headers
# Usage:
#   greentea_extract_greentea_libdnn_version()
function(greentea_extract_greentea_libdnn_version)
  set(GREENTEA_LIBDNN_GIT_VERSION "unknown")
  find_package(Git)
  if(GIT_FOUND)
    execute_process(COMMAND ${GIT_EXECUTABLE} describe --tags --always --dirty
                    ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
                    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
                    OUTPUT_VARIABLE GREENTEA_LIBDNN_GIT_VERSION
                    RESULT_VARIABLE __git_result)
    if(NOT ${__git_result} EQUAL 0)
      set(GREENTEA_LIBDNN_GIT_VERSION "unknown")
    endif()
  endif()

  set(GREENTEA_LIBDNN_GIT_VERSION ${GREENTEA_LIBDNN_GIT_VERSION} PARENT_SCOPE)


  greentea_parse_header(${GREENTEA_INCLUDE_DIR}/version.hpp GREENTEA_LIBDNN_VERSION_LINES GREENTEA_LIBDNN_MAJOR GREENTEA_LIBDNN_MINOR GREENTEA_LIBDNN_PATCH)
  set(GREENTEA_LIBDNN_VERSION "${GREENTEA_LIBDNN_MAJOR}.${GREENTEA_LIBDNN_MINOR}.${GREENTEA_LIBDNN_PATCH}" PARENT_SCOPE)

endfunction()


################################################################################################
# Prints accumulated Greentea LibDNN configuration summary
# Usage:
#   greentea_print_configuration_summary()

function(greentea_print_configuration_summary)
  greentea_extract_greentea_libdnn_version()
  set(GREENTEA_VERSION ${GREENTEA_VERSION} PARENT_SCOPE)

  greentea_merge_flag_lists(__flags_rel CMAKE_CXX_FLAGS_RELEASE CMAKE_CXX_FLAGS)
  greentea_merge_flag_lists(__flags_deb CMAKE_CXX_FLAGS_DEBUG   CMAKE_CXX_FLAGS)

  greentea_status("")
  greentea_status("******************* Greentea LibDNN Configuration Summary *******************")
  greentea_status("General:")
  greentea_status("  Version           :   ${GREENTEA_TARGET_VERSION}")
  greentea_status("  Git               :   ${GREENTEA_GIT_VERSION}")
  greentea_status("  System            :   ${CMAKE_SYSTEM_NAME}")
  greentea_status("  C++ compiler      :   ${CMAKE_CXX_COMPILER}")
  greentea_status("  Release CXX flags :   ${__flags_rel}")
  greentea_status("  Debug CXX flags   :   ${__flags_deb}")
  greentea_status("  Build type        :   ${CMAKE_BUILD_TYPE}")
  greentea_status("")
  greentea_status("  BUILD_SHARED_LIBS :   ${BUILD_SHARED_LIBS}")
  greentea_status("")
  greentea_status("Dependencies:")
  greentea_status("  OpenCL            : " HAVE_OPENCL THEN  "Yes" ELSE "No")
  greentea_status("  ViennaCL          : " HAVE_VIENNACL THEN  "Yes" ELSE "No")
  greentea_status("  CUDA              : " HAVE_CUDA THEN "Yes (ver. ${CUDA_VERSION})" ELSE "No" )
  greentea_status("")
  greentea_status("Install:")
  greentea_status("  Install path      :   ${CMAKE_INSTALL_PREFIX}")
  greentea_status("")
endfunction()
