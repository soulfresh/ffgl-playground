cmake_minimum_required(VERSION 3.18)

###
# Add delimiters to each entry in the given list.
# @param result - The variable to set
# @param delim - The delimiter to use
###
function (ListToString result delim)
  list(GET ARGV 2 temp)
  math(EXPR N "${ARGC}-1")
  foreach(IDX RANGE 3 ${N})
    list(GET ARGV ${IDX} STR)
    set(temp "${temp}${delim}${STR}")
  endforeach()
  set(${result} "${temp}" PARENT_SCOPE)
endfunction(ListToString)

# Example:
# ListToString(ffgl_src ";\n" ${FFGL_SOURCES})

###
# Nicely print the contents of the given list.
###
function(PrintList list)
  ListToString(temp ";\n" ${FFGL_SOURCES})
  message(${temp})
endfunction()
