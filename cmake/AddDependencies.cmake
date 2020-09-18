message(CHECK_START "Finding Nanopolish Dependencies")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

SET(CMAKE_FIND_LIBRARY_SUFFIXES .so .dylib ${CMAKE_FIND_LIBRARY_SUFFIXES})
find_package(OpenMP REQUIRED CXX)

if(BUILD_SHARED_LIBS)
    message(STATUS "BUILDING SHARED LIBS")
    SET(CMAKE_FIND_LIBRARY_SUFFIXES .so .dylib ${CMAKE_FIND_LIBRARY_SUFFIXES})
else(NOT BUILD_SHARED_LIBS)
    message(STATUS "BUILDING STATIC LIBS")
    SET(CMAKE_FIND_LIBRARY_SUFFIXES .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
endif(BUILD_SHARED_LIBS)

############################################################################################################
find_package(HTSlib REQUIRED htslib)
find_package(Eigen3 REQUIRED NO_MODULE)

#set(HDF5_FIND_DEBUG TRUE)
set(HDF5_PREFER_PARALLEL TRUE)
find_package(HDF5 1.10.0 COMPONENTS C CXX REQUIRED)

############################################################################################################
set(nanopolish_LINK_LIBRARIES
        HTSlib::HTSlib
        Eigen3::Eigen
        ${CMAKE_DL_LIBS}
        -fopenmp
        )

if (NOT TARGET hdf5::hdf5)
    list(APPEND nanopolish_LINK_LIBRARIES ${HDF5_LIBRARIES})
    set(nanopolish_INCLUDE_DIRS
            ${HDF5_INCLUDE_DIRS})
    if(NOT APPLE)
        list(APPEND nanopolish_LINK_LIBRARIES aec)
    endif(NOT APPLE)
else()
    list(APPEND nanopolish_LINK_LIBRARIES hdf5::hdf5)
endif()
############################################################################################################
############################################################################################################
list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "all components found")
