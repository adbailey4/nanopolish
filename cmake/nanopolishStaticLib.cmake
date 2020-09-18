message(CHECK_START "Testing")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

#print_target_properties(OpenMP::OpenMP_CXX)

SET(CMAKE_FIND_LIBRARY_SUFFIXES .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
unset_cmake_variables("OpenMP")
find_package(OpenMP REQUIRED CXX)
#message("UNSET1")
#dump_cmake_variables("OpenMP")
#unset_cmake_variables("OpenMP")
#message("UNSET1+2")
#dump_cmake_variables("OpenMP")

set(test_libs
        OpenMP::OpenMP_CXX
        )
#message("UNSET2")
#print_target_properties(OpenMP::OpenMP_CXX)
#set_property(TARGET OpenMP::OpenMP_CXX PROPERTY TYPE)

#dump_cmake_variables("OpenMP")
#message(STATUS ${test_static_libs})
#message("UNSET3")
SET(CMAKE_FIND_LIBRARY_SUFFIXES .so .dylib ${CMAKE_FIND_LIBRARY_SUFFIXES})
unset_cmake_variables("OpenMP")
find_package(OpenMP REQUIRED CXX)
#print_target_properties(OpenMP::OpenMP_CXX)
dump_cmake_variables("OpenMP")
print_target_properties(OpenMP::OpenMP_CXX)
set(test_libs OpenMP::OpenMP_CXX ${test_libs})
foreach(lib ${test_libs})
    message(${lib})
    print_target_properties(${lib})
endforeach()

############################################################################################################
############################################################################################################
list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "all components found")
