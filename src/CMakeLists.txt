# --[ Greenea LibDNN library

# TODO(naibaf7): Check if it's needed or not since with
# this macro we get `hdrs` and `srcs` in one, but below
# we will need only `hdrs` to be copied in the install prefix.

# creates 'srcs' lists
#greentea_pickup_greentea_sources(${PROJECT_SOURCE_DIR})

file(GLOB_RECURSE srcs "${PROJECT_SOURCE_DIR}/src/*.cpp")
file(GLOB_RECURSE hdrs "${PROJECT_SOURCE_DIR}/include/*.hpp")

add_library(${PROJECT_LIBRARY_TARGET_NAME} ${srcs} ${hdrs})

# configure the library target
target_include_directories(
    ${PROJECT_LIBRARY_TARGET_NAME} PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include/greentea>)

target_link_libraries(
    ${PROJECT_LIBRARY_TARGET_NAME} ${GREENTEA_LINKER_LIBS})

# TODO(naibaf7): Is it needed?
# greentea_default_properties(greentea_libdnn)

set_target_properties(${PROJECT_LIBRARY_TARGET_NAME} PROPERTIES
    VERSION   ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION})

# ---[ Install and export library

install(FILES ${hdrs} "${CMAKE_BINARY_DIR}/greentea_libdnn_config.h"
        DESTINATION ${INCLUDE_INSTALL_DIR})

install(TARGETS ${PROJECT_LIBRARY_TARGET_NAME}
        EXPORT  ${CMAKE_TARGETS_NAME}
        RUNTIME DESTINATION lib
        LIBRARY DESTINATION lib)
