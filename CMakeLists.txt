cmake_minimum_required(VERSION 3.15)
project(nanopolish VERSION 0.11.1)
include(GNUInstallDirs)
set(BUILD_SHARED_LIBS  "ON" CACHE STRING "Default build shared library")
# visibility settings
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

### Require out-of-source builds
file(TO_CMAKE_PATH "${PROJECT_BINARY_DIR}/CMakeLists.txt" LOC_PATH)
if(EXISTS "${LOC_PATH}")
    message(FATAL_ERROR "You cannot build in a source directory (or any directory with a CMakeLists.txt file). Please make a build subdirectory. Feel free to remove CMakeCache.txt and CMakeFiles.")
endif()

if(NOT APPLE)
    set(CMAKE_INSTALL_RPATH $ORIGIN)
endif()

############################################################################################################
# Find dependencies
############################################################################################################
#set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
#message("CMAKE_MODULE_PATH Prefix: ${CMAKE_MODULE_PATH}")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")
message(STATUS "CMakeInstall Prefix: ${CMAKE_INSTALL_PREFIX}")
#include(${PROJECT_SOURCE_DIR}/cmake/functions/print_target_properties.cmake)
#include(${PROJECT_SOURCE_DIR}/cmake/functions/dump_cmake_variables.cmake)
#include(${PROJECT_SOURCE_DIR}/cmake/nanopolishStaticLib.cmake)
#add_subdirectory(static_lib)
#add_subdirectory(shared_lib)
include(${PROJECT_SOURCE_DIR}/cmake/AddDependencies.cmake)
############################################################################################################
# Create object library
############################################################################################################
add_library(nanopolish_objlib OBJECT
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


target_link_libraries(nanopolish_objlib
        PUBLIC
        Eigen3::Eigen)

target_include_directories(nanopolish_objlib
        PUBLIC
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/nanopolish>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/alignment>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/common>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/hmm>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/pore_model>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie>
        ${nanopolish_INCLUDE_DIRS}
        PRIVATE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/fast5/include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/fast5/include/fast5>)

set_target_properties(nanopolish_objlib PROPERTIES
        POSITION_INDEPENDENT_CODE 1)
target_compile_features(nanopolish_objlib PUBLIC cxx_std_11)
target_compile_options(nanopolish_objlib PRIVATE
#        -Wall
        #        -Werror
        #        -Wno-error=maybe-uninitialized
#        -Wconversion
#        -Wno-unused-result
#        -Wpedantic
        $<$<CONFIG:RELEASE>:-g0>
        $<$<CONFIG:RELEASE>:-O3>
        $<$<CONFIG:DEBUG>:-ggdb3>
        $<$<CONFIG:DEBUG>:-O0>
        $<$<CONFIG:DEBUG>:-ggdb3>
        )
target_compile_definitions(nanopolish_objlib PRIVATE
        $<$<CONFIG:RELEASE>:NDEBUG>
        $<$<CONFIG:RELEASE>:BOOST_DISABLE_ASSERTS>
        )

############################################################################################################
# Create library
############################################################################################################
add_library(nanopolishlib $<TARGET_OBJECTS:nanopolish_objlib>)
target_link_libraries(nanopolishlib
        PUBLIC
        nanopolish_objlib
        ${nanopolish_LINK_LIBRARIES})
#        PRIVATE
#        ${nanopolish_PRIVATE_LINK_LIBRARIES})
set_target_properties(nanopolishlib
        PROPERTIES
        OUTPUT_NAME "nanopolish"
        PREFIX ""
        DEFINE_SYMBOL ""
        VERSION ${PROJECT_VERSION})

#############################################################################################################
## Create executable
#############################################################################################################
add_executable(nanopolish src/main/nanopolish.cpp)
if (NOT APPLE AND NOT BUILD_SHARED_LIBS)
    message(STATUS "not APPLE")
#    target_link_libraries(nanopolish PUBLIC -static)
    target_link_libraries(nanopolish PUBLIC -static -static-libgcc -static-libstdc++)
endif(NOT APPLE AND NOT BUILD_SHARED_LIBS)

target_link_libraries(nanopolish PUBLIC nanopolishlib)
target_include_directories(nanopolish
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/fast5/include
        ${CMAKE_CURRENT_SOURCE_DIR}/fast5/include/fast5)

############################################################################################################
# Create test
############################################################################################################
add_executable(nanopolish_test src/test/nanopolish_test.cpp)
if (NOT APPLE AND NOT BUILD_SHARED_LIBS)
    message(STATUS "not APPLE")
#    target_link_libraries(nanopolish_test PUBLIC -static)
    target_link_libraries(nanopolish_test PUBLIC -static -static-libgcc -static-libstdc++)
endif(NOT APPLE AND NOT BUILD_SHARED_LIBS)

target_link_libraries(nanopolish_test PUBLIC nanopolishlib)
target_include_directories(nanopolish_test
        PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/src/test/
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/fast5/include
        ${CMAKE_CURRENT_SOURCE_DIR}/fast5/include/fast5)

############################################################################################################
# Install
############################################################################################################
install(TARGETS nanopolishlib nanopolish nanopolish_objlib
        EXPORT nanopolishTargets
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
                COMPONENT nanopolish_RunTime
                NAMELINK_COMPONENT nanopolish_Development
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
                COMPONENT nanopolish_Development
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
                COMPONENT nanopolish_RunTime
        INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        )
############################################################################################################
install(FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_squiggle_read.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_read_db.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_scorereads.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_call_variants.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_haplotype.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/pore_model/nanopolish_builtin_models.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/pore_model/nanopolish_model_names.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/pore_model/nanopolish_pore_model_set.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/pore_model/nanopolish_poremodel.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_phase_reads.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_polya_estimator.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_methyltrain.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_train_poremodel_from_basecalls.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_iupac.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/progress.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/logsum.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_alphabet.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_common.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_matrix.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_fast5_io.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_klcs.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_bam_processor.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_variant.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/profiler.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_bam_utils.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_index.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/alignment/nanopolish_eventalign.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/alignment/nanopolish_alignment_db.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/alignment/nanopolish_anchor.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_getmodel.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_hmm_input_sequence.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_transition_parameters.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_emissions.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_duration_model.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_profile_hmm.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_profile_hmm_r7.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_profile_hmm_r9.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_extract.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_vcf2fasta.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_raw_loader.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie/scrappie_common.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie/scrappie_stdlib.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie/scrappie_structures.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie/event_detection.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/stdaln.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_call_methylation.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_variant_db.h
        DESTINATION
        ${CMAKE_INSTALL_INCLUDEDIR}/nanopolish
        )
############################################################################################################
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
        cmake/nanopolishConfigVersion.cmake
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY AnyNewerVersion
)

install(EXPORT nanopolishTargets
        FILE nanopolishTargets.cmake
        NAMESPACE nanopolish::
        DESTINATION
        ${CMAKE_INSTALL_LIBDIR}/cmake/nanopolish
        )

configure_file(cmake/nanopolishConfig.cmake
        "${CMAKE_CURRENT_BINARY_DIR}/cmake/nanopolishConfig.cmake"
        COPYONLY
        )

configure_file(cmake/modules/FindHTSlib.cmake
        "${CMAKE_CURRENT_BINARY_DIR}/cmake/modules/FindHTSlib.cmake"
        COPYONLY
        )

install(FILES
        "${CMAKE_CURRENT_BINARY_DIR}/cmake/nanopolishConfig.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/cmake/nanopolishConfigVersion.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/cmake/modules/FindHTSlib.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/nanopolish
        )
############################################################################################################
# export to package registry
############################################################################################################
set(CMAKE_EXPORT_PACKAGE_REGISTRY ON)
export(PACKAGE nanopolish)

############################################################################################################
# uninstall
############################################################################################################
if(NOT TARGET uninstall)
    configure_file(
            ${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in
            ${CMAKE_CURRENT_BINARY_DIR}/cmake/cmake_uninstall.cmake
            IMMEDIATE @ONLY)
    add_custom_target(uninstall
            COMMAND ${CMAKE_COMMAND} -P
            ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
endif()
