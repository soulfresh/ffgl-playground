cmake_minimum_required(VERSION 3.18)

# Debug a variable
# function (ListToString result delim)
#     list(GET ARGV 2 temp)
#     math(EXPR N "${ARGC}-1")
#     foreach(IDX RANGE 3 ${N})
#         list(GET ARGV ${IDX} STR)
#         set(temp "${temp}${delim}${STR}")
#     endforeach()
#     set(${result} "${temp}" PARENT_SCOPE)
# endfunction(ListToString)
#
# ListToString(ffgl_src ";\n" ${FFGL_SOURCES})

add_subdirectory(Gradients)

### TEMP APP ###
set(sources main.cpp)

add_executable(lolpxl
  ${sources}
  ${FFGL_SOURCES}
)

target_include_directories(lolpxl PUBLIC
  ${FFGL_INCLUDE_DIRS}
  ${GLM_INCLUDE_DIRS}
)

# -framework linker flags
find_library(OPENGL OpenGL REQUIRED)
target_link_libraries(lolpxl ${OPENGL})
