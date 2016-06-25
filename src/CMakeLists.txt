# --[ Greenea LibDNN library

# creates 'srcs' lists
greentea_pickup_greentea_sources(${PROJECT_SOURCE_DIR})

add_library(greentea_libdnn ${srcs})
target_link_libraries(greentea_libdnn ${GREENTEA_LINKER_LIBS})
greentea_default_properties(greentea_libdnn)
set_target_properties(greentea_libdnn PROPERTIES
    VERSION   ${GREENTEA_TARGET_VERSION}
    SOVERSION ${GREENTEA_TARGET_SOVERSION}
    )

# ---[ Install
install(DIRECTORY ${GREENEA_INCLUDE_DIR}/greentea DESTINATION include)
install(TARGETS greentea_libdnn EXPORT GreenteaLibDNNTargets DESTINATION lib)
