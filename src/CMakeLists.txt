cmake_minimum_required(VERSION 3.18)

include(Projects.cmake)

# Include the cmake list for each subdirectory.
AddAllPlugins()

### TEMP APP ###
# set(sources main.cpp)
#
# add_executable(lolpxl
#   ${sources}
#   ${FFGL_SOURCES}
# )
#
# target_include_directories(lolpxl PUBLIC
#   ${FFGL_INCLUDE_DIRS}
#   ${GLM_INCLUDE_DIRS}
# )
#
# # -framework linker flags
# find_library(OPENGL OpenGL REQUIRED)
# target_link_libraries(lolpxl ${OPENGL})
