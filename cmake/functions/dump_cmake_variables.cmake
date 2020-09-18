function(dump_cmake_variables)
    get_cmake_property(_variableNames VARIABLES)
    list (SORT _variableNames)
    foreach (_variableName ${_variableNames})
        if (ARGV0)
            unset(MATCHED)
            string(REGEX MATCH ${ARGV0} MATCHED ${_variableName})
            if (NOT MATCHED)
                continue()
            endif()
        endif()
        message(STATUS "${_variableName}=${${_variableName}}")
    endforeach()
endfunction()

function(assertdef VARNAME RESULT_LIST)
    if(NOT DEFINED ${VARNAME})
        message(SEND_ERROR "Error, the variable ${VARNAME} is not defined!")
    endif()
    list(APPEND RESULT_LIST )

    append(${RESULT_LIST} ${VARNAME} PARENT_SCOPE)
endfunction()


function(unset_cmake_variables)
    get_cmake_property(_variableNames VARIABLES)
    list (SORT _variableNames)
    foreach (_variableName ${_variableNames})
        if (ARGV0)
            unset(MATCHED)
            unset(MATCHED2)

            string(REGEX MATCH ${ARGV0} MATCHED ${_variableName})
            string(REGEX MATCH "PC_HTSLIB_STATIC_LIBRARIES" MATCHED2 ${_variableName})

            if (NOT MATCHED)
                continue()
            endif()
        endif()
        unset(${_variableName})
        unset(${_variableName} CACHE)
        unset(${_variableName} PARENT_SCOPE)

#        message(STATUS "${_variableName}=${${_variableName}}")
    endforeach()
endfunction()
