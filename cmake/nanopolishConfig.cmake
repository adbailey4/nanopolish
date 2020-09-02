get_filename_component(nanopolish_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
include(CMakeFindDependencyMacro)
# Same syntax as find_package
find_dependency(OpenMP REQUIRED)

#if(NOT TARGET nanopolish::nanopolish_objlib)
include("${CMAKE_CURRENT_LIST_DIR}/nanopolishTargets.cmake")
#endif()


#get_filename_component(JSONUtils_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
#include(CMakeFindDependencyMacro)
#
#find_dependency(Boost 1.55 REQUIRED COMPONENTS regex)
#find_dependency(RapidJSON 1.0 REQUIRED MODULE)
#
#if(NOT TARGET JSONUtils::JSONUtils)
#    include("${JSONUtils_CMAKE_DIR}/JSONUtilsTargets.cmake")
#endif()
