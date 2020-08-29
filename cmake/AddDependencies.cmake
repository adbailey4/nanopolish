message(CHECK_START "Finding Nanopolish Dependencies")
list(APPEND CMAKE_MESSAGE_INDENT "  ")
############################################################################################################
# DL LIBRARY
############################################################################################################
message(CHECK_START "Finding DL LIBRARY")
find_library(LIBDL_LIBRARY NAMES dl)
if(NOT LIBDL_LIBRARY)
    message(FATAL_ERROR "dl library not found")
else()
    message(CHECK_PASS "found: ${LIBDL_LIBRARY}")
endif()
############################################################################################################
# ZLIB LIBRARY
############################################################################################################
message(CHECK_START "Finding ZLIB PACKAGE")
find_package(ZLIB)
if(NOT ZLIB_FOUND)
    message(FATAL_ERROR "zlib package not found")
else()
    message(CHECK_PASS "found: ${ZLIB_LIBRARY}")
endif()
############################################################################################################
# M LIBRARY
############################################################################################################
message(CHECK_START "Finding LIBM LIBRARY")
find_library(LIBM_LIBRARY NAMES m)
if(NOT LIBM_LIBRARY)
    message(FATAL_ERROR "m library not found")
else()
    message(CHECK_PASS "found: ${LIBM_LIBRARY}")
endif()
############################################################################################################
# pthread LIBRARY
############################################################################################################
message(CHECK_START "Finding LIBPTHREAD LIBRARY")
find_library(LIBPTHREAD_LIBRARY NAMES pthread)
if(NOT LIBPTHREAD_LIBRARY)
    message(FATAL_ERROR "pthread library not found")
else()
    message(CHECK_PASS "found: ${LIBPTHREAD_LIBRARY}")
endif()
############################################################################################################
# BZ2 LIBRARY
############################################################################################################
message(CHECK_START "Finding bz2 LIBRARY")
find_library(LIBBZ2_LIBRARY NAMES bz2)
if(NOT LIBBZ2_LIBRARY)
    message(FATAL_ERROR "bz2 library not found")
else()
    message(CHECK_PASS "found: ${LIBBZ2_LIBRARY}")
endif()
############################################################################################################
# CURL LIBRARY
############################################################################################################
message(CHECK_START "Finding curl LIBRARY")
find_library(LIBCURL_LIBRARY NAMES curl)
if(NOT LIBCURL_LIBRARY)
    message(FATAL_ERROR "curl library not found")
else()
    message(CHECK_PASS "found: ${LIBCURL_LIBRARY}")
endif()
############################################################################################################
# LZMA LIBRARY
############################################################################################################
message(CHECK_START "Finding lzma LIBRARY")
find_library(LIBLZMA_LIBRARY NAMES lzma)
if(NOT LIBLZMA_LIBRARY)
    message(FATAL_ERROR "lzma library not found")
else()
    message(CHECK_PASS "found: ${LIBLZMA_LIBRARY}")
endif()
############################################################################################################
# HDF LIBRARY
############################################################################################################
message(CHECK_START "Finding hdf5 PACKAGE")
find_package(HDF5)
#find_library(HDF5_LIBRARIES libhdf5.a
#        HINTS ${NANOPOLISH_HOME}/lib
#        ${CMAKE_INSTALL_PREFIX}/lib
#        /usr/lib
#        ${LIBDIR})
#
#find_path(HDF5_INCLUDE_DIRS hdf5.h
#        HINTS ${HDF5_LIBRARIES}
#        "${NANOPOLISH_HOME}/include"
#        ${CMAKE_INSTALL_PREFIX}/include
#        ${INCLUDEDIR}
#        /usr/include)
if(NOT HDF5_FOUND)
    message(FATAL_ERROR "hdf5 package not found")
else()
    message(CHECK_PASS "found: ${HDF5_LIBRARIES} ${HDF5_INCLUDE_DIRS}")
endif()
############################################################################################################
# EIGEN LIBRARY
############################################################################################################
message(CHECK_START "Finding eigen3 PACKAGE")
find_package(eigen3)
if(NOT eigen3_FOUND)
    message(FATAL_ERROR "eigen3 package not found")
else()
    message(CHECK_PASS "found: ${EIGEN3_INCLUDE_DIR}")
endif()

#find_path(EIGEN3_INCLUDE_DIR Eigen HINTS
#        ${CMAKE_INSTALL_PREFIX}/include
#        ${NANOPOLISH_HOME}
#        ${INCLUDEDIR}
#        PATH_SUFFIXES eigen3 eigen)
############################################################################################################
# HTSLIB LIBRARY
############################################################################################################
find_library(HTSLIB_LIBRARY NAMES libhts.a
        HINTS "${NANOPOLISH_HOME}/htslib"
        ${CMAKE_INSTALL_PREFIX}/lib
        /usr/lib
        ${LIBDIR})

find_path(HTSLIB_INCLUDE_DIR htslib/hts.h
        HINTS ${HTSLIB_LIBRARY}
        ${CMAKE_INSTALL_PREFIX}/include
        "${NANOPOLISH_HOME}/htslib"
        /usr/include
        ${INCLUDEDIR})
message(CHECK_START "Finding htslib LIBRARY")
if(NOT HTSLIB_INCLUDE_DIR OR NOT HTSLIB_LIBRARY)
    message(FATAL_ERROR "htslib package not found")
else()
    message(CHECK_PASS "found: ${HTSLIB_LIBRARY} ${HTSLIB_INCLUDE_DIR}")
endif()

############################################################################################################
# OpenMP LIBRARY
############################################################################################################

message(CHECK_START "Finding OpenMP PACKAGE")
find_package(OpenMP)
#if(OpenMP_CXX_FOUND)
#    message(FATAL_ERROR "OpenMP package not found")
#else()
#    message(CHECK_PASS "found: ${HTSLIB_LIBRARY} ${HTSLIB_INCLUDE_DIR}")
##    target_link_libraries(MyTarget PUBLIC OpenMP::OpenMP_CXX)
#endif()

if(NOT TARGET OpenMP::OpenMP_CXX)
    find_package(Threads REQUIRED)
    if(Threads_FOUND)
        message(FATAL_ERROR "OpenMP package not found")
    else()
        add_library(OpenMP::OpenMP_CXX IMPORTED INTERFACE)
        set_property(TARGET OpenMP::OpenMP_CXX
                PROPERTY INTERFACE_COMPILE_OPTIONS ${OpenMP_CXX_FLAGS})
        # Only works if the same flag is passed to the linker; use CMake 3.9+ otherwise (Intel, AppleClang)
        set_property(TARGET OpenMP::OpenMP_CXX
                PROPERTY INTERFACE_LINK_LIBRARIES ${OpenMP_CXX_FLAGS} Threads::Threads)
        message(CHECK_PASS "found: ${OpenMP_CXX_FLAGS}")
    endif()
    message(CHECK_PASS "found: ${OpenMP_CXX_FLAGS}")
else()
    message(CHECK_PASS "found: ${OpenMP_CXX_FLAGS}")
endif()

############################################################################################################
############################################################################################################
list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "all components found")
