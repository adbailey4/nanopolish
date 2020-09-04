message(CHECK_START "Finding Nanopolish Dependencies")
list(APPEND CMAKE_MESSAGE_INDENT "  ")
############################################################################################################
get_filename_component(nanopolish_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
include(CMakeFindDependencyMacro)
# Same syntax as find_package
############################################################################################################
enable_language(Fortran)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}" "${CMAKE_CURRENT_LIST_DIR}/modules")
find_dependency(OpenMP REQUIRED)
find_dependency(ZLIB REQUIRED)
find_dependency(HDF5 1.10.4 COMPONENTS C CXX HL Fortran)
find_dependency(Eigen3 3.2 REQUIRED NO_MODULE)
find_dependency(HTSlib REQUIRED htslib)
############################################################################################################
include("${CMAKE_CURRENT_LIST_DIR}/nanopolishTargets.cmake")
############################################################################################################
list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "all components found")

