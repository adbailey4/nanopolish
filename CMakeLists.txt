cmake_minimum_required(VERSION 3.8)
project(nanopolish)

set(CMAKE_CXX_STANDARD 11)
SET(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -fopenmp -fsigned-char" )
SET(CMAKE_CXX_COMPILER "/usr/local/bin/g++")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -gdwarf-3")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -gdwarf-3")

find_path(EIGEN3_INCLUDE_DIR Eigen HINTS
        ${CMAKE_INSTALL_PREFIX}/include
        ${NANOPOLISH_HOME}
        ${INCLUDEDIR}
        PATH_SUFFIXES eigen3 eigen)

message(EIGEN3_INCLUDE_DIR: "${EIGEN3_INCLUDE_DIR}")
include_directories(${EIGEN3_INCLUDE_DIR})


#set(EIGEN_HOME "none" CACHE STRING "Some user-specified option")
#set(EIGEN_HOME "none" CACHE STRING "Some user-specified option")
include_directories(${CMAKE_SOURCE_DIR}/src)
include_directories(${CMAKE_SOURCE_DIR}/fast5/include)
#include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(/usr/local/include)
#include_directories(/usr/include)
include_directories(${CMAKE_SOURCE_DIR}/src/alignment)
include_directories(${CMAKE_SOURCE_DIR}/src/common)
include_directories(${CMAKE_SOURCE_DIR}/src/hmm)
include_directories(${CMAKE_SOURCE_DIR}/src/main)
include_directories(${CMAKE_SOURCE_DIR}/src/pore_model)
include_directories(${CMAKE_SOURCE_DIR}/src/test)
include_directories(${CMAKE_SOURCE_DIR}/src/thirdparty)
include_directories(${CMAKE_SOURCE_DIR}/src/thirdparty/scrappie)

link_directories(/usr/local/lib)

#link_directories(${CMAKE_SOURCE_DIR}/lib)


set(CMAKE_VERBOSE_MAKEFILE ON)

set(NP_LIBRARY -lz -lm -lhts -ldl -lpthread -lhdf5)


#add_custom_command(
#        OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/src/main/nanopolish.o
#        COMMAND make
#        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/nanopolish/
#)

set(object_files
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_call_variants.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_call_methylation.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_extract.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_getmodel.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_haplotype.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_index.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_methyltrain.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_phase_reads.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_raw_loader.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_read_db.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_variant_db.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_vcf2fasta.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_train_poremodel_from_basecalls.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_squiggle_read.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_scorereads.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_duration_model.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_profile_hmm.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_profile_hmm_r7.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_profile_hmm_r9.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/hmm/nanopolish_transition_parameters.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/fs_support.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/logsum.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_alphabet.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_bam_processor.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_bam_utils.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_common.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_fast5_io.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_iupac.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_klcs.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/common/nanopolish_variant.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/alignment/nanopolish_alignment_db.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/alignment/nanopolish_anchor.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/alignment/nanopolish_eventalign.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/pore_model/nanopolish_poremodel.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/pore_model/nanopolish_pore_model_set.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/pore_model/nanopolish_model_names.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/training_core.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/nanopolish_polya_estimator.o
#        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie/util.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie/scrappie_common.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie/event_detection.o
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/stdaln.o)

set(non_object_files
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
#        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie/util.c
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie/scrappie_common.c
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/scrappie/event_detection.c
        ${CMAKE_CURRENT_SOURCE_DIR}/src/thirdparty/stdaln.c)

#add_library(nanopolish_object_files STATIC ${non_object_files})


#add_custom_target(
#        nanopolish_o
#        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/main/nanopolish.o)


set(NANOPOLISH
        src/main/nanopolish.cpp)

set(SOURCE_FILES
        src/
        src/hmm
        src/common
        src/alignment
        src/builtin_models
        src/main
        src/test
        src/thirdparty
        src/thirdparty/scrappie)

add_executable(nanopolish ${NANOPOLISH} ${non_object_files})

target_link_libraries(nanopolish ${NP_LIBRARY}) #${nanopolish_object_files}

# bwa mem -x ont2d ~/data/references/ecoli/ecoli_k12_mg1655.fa dnacanonical.fa | samtools sort -o dnacanonical.sorted.bam -T reads.tmp | samtools index dnacanonical.sorted.bam
