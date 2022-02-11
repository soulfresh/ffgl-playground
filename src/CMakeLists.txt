cmake_minimum_required(VERSION 3.18)

include(Projects.cmake)

# Include the cmake list for each subdirectory.
AddAllPlugins()

### TEMP APP ###
# add_executable(DUMMY
#   dummy.cpp
#   $<TARGET_OBJECTS:FFGL>
# )
#
# target_include_directories(DUMMY PUBLIC
#   ${DEPS_INCLUDE_DIRS}
#   ${LIB_INCLUDE_DIRS}
# )

# target_precompile_headers(DUMMY PUBLIC ${DEPS_HEADERS} ${LIBS_HEADERS})

