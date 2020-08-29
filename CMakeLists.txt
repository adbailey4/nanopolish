cmake_minimum_required(VERSION 3.8)

set(CMAKE_CXX_STANDARD 11)
SET(CMAKE_CXX_FLAGS "-g -Wall -std=c++11 -fopenmp -fsigned-char -DBOOST_NO_CXX11_SCOPED_ENUMS")
SET(CMAKE_CXX_COMPILER "/usr/local/bin/g++")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -gdwarf-3")
set(CMAKE_C_FLAGS_DEBUG  "${CMAKE_C_FLAGS_DEBUG} -O0 -g -Wall --pedantic -fopenmp -funroll-loops  -DNDEBUG")
project(nanopolish)
### Require out-of-source builds
file(TO_CMAKE_PATH "${PROJECT_BINARY_DIR}/CMakeLists.txt" LOC_PATH)
if(EXISTS "${LOC_PATH}")
    message(FATAL_ERROR "You cannot build in a source directory (or any directory with a CMakeLists.txt file). Please make a build subdirectory. Feel free to remove CMakeCache.txt and CMakeFiles.")
endif()

set(CMAKE_VERBOSE_MAKEFILE ON)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
#message("CMAKE_MODULE_PATH Prefix: ${CMAKE_MODULE_PATH}")
#message("CMakeInstall Prefix: ${CMAKE_INSTALL_PREFIX}")
include(AddDependencies)

set(CMAKE_VERBOSE_MAKEFILE ON)

set(nanopolish_DEPENDENCIES z m hts dl pthread hdf5)
#set(nanopolish_DEPENDENCIES ${HDF5_LIBRARIES} ${HTSLIB_LIBRARY} ${LIBCURL_LIBRARY} ${ZLIB_LIBRARIES} ${LIBLZMA_LIBRARY} ${LIBBZ2_LIBRARY} ${ZLIB_LIBRARIES} ${LIBM_LIBRARY} ${LIBDL_LIBRARY} ${LIBPTHREAD_LIBRARY})

set(nanopolish_SOURCE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_call_variants.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_call_methylation.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_extract.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_getmodel.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_polya_estimator.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_vcf2fasta.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_haplotype.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_index.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_methyltrain.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_phase_reads.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_raw_loader.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_read_db.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_variant_db.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_train_poremodel_from_basecalls.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_squiggle_read.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_scorereads.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_duration_model.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_profile_hmm.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_profile_hmm_r7.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_profile_hmm_r9.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_transition_parameters.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/fs_support.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/logsum.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_alphabet.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_bam_processor.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_bam_utils.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_common.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_fast5_io.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_iupac.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_klcs.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_variant.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/alignment/nanopolish_alignment_db.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/alignment/nanopolish_anchor.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/alignment/nanopolish_eventalign.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/pore_model/nanopolish_poremodel.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/pore_model/nanopolish_pore_model_set.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/pore_model/nanopolish_model_names.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/training_core.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie/scrappie_common.c
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie/event_detection.c
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/stdaln.c)


set(nanopolish_MAIN src/main/nanopolish.cpp)
add_library(nanopolish_LIBRARY STATIC ${nanopolish_SOURCE})
target_link_libraries(nanopolish_LIBRARY
        PUBLIC
        ${nanopolish_DEPENDENCIES}
        OpenMP::OpenMP_CXX)

set_target_properties(nanopolish_LIBRARY PROPERTIES
        OUTPUT_NAME "nanopolish"
        PREFIX ""
        DEFINE_SYMBOL "")

target_include_directories(nanopolish_LIBRARY
        PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        ${CMAKE_CURRENT_SOURCE_DIR}/src/alignment
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm
        ${CMAKE_CURRENT_SOURCE_DIR}/src/main
        ${CMAKE_CURRENT_SOURCE_DIR}/src/pore_model
        ${CMAKE_CURRENT_SOURCE_DIR}/src/test
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie
        ${EIGEN3_INCLUDE_DIR}
        ${HDF5_INCLUDE_DIRS}
        ${ZLIB_INCLUDE_DIRS}
        ${HDF5_INCLUDE_DIRS}
        ${HTSLIB_INCLUDE_DIRS}
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/fast5/include
        ${CMAKE_CURRENT_SOURCE_DIR}/fast5/include/fast5)

install(TARGETS nanopolish_LIBRARY DESTINATION nanopolish-install/bin)

add_executable(nanopolish ${nanopolish_MAIN})
target_link_libraries(nanopolish PUBLIC nanopolish_LIBRARY)
target_include_directories(nanopolish
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/fast5/include
        ${CMAKE_CURRENT_SOURCE_DIR}/fast5/include/fast5)
