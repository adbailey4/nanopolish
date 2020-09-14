message(CHECK_START "Finding Nanopolish Dependencies")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

IF(NOT FIND_STATIC)
    message(STATUS "FIND_STATIC")
    SET(CMAKE_FIND_LIBRARY_SUFFIXES .so .dylib ${CMAKE_FIND_LIBRARY_SUFFIXES})
ELSE(FIND_STATIC)
    message(STATUS "not FIND_STATIC")
    SET(CMAKE_FIND_LIBRARY_SUFFIXES .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
ENDIF(NOT FIND_STATIC)

############################################################################################################
find_package(HTSlib REQUIRED htslib)
find_package(Eigen3 REQUIRED NO_MODULE)
find_package(OpenMP REQUIRED CXX)

#set(HDF5_FIND_DEBUG TRUE)
set(HDF5_PREFER_PARALLEL TRUE)
find_package(HDF5 1.10.0 COMPONENTS C CXX REQUIRED)
#find_package(HDF5 1.10.4 COMPONENTS C CXX)

############################################################################################################
set(nanopolish_LINK_LIBRARIES
        HTSlib::HTSlib
        Eigen3::Eigen
        ${CMAKE_DL_LIBS}
        OpenMP::OpenMP_CXX
        )

if (NOT TARGET hdf5::hdf5)
    list(APPEND nanopolish_LINK_LIBRARIES "${HDF5_LIBRARIES}")
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
