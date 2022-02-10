###
# EXPORTS
# -------
# GLM_INCLUDE_DIRS
#
# See https://github.com/g-truc/glm/blob/master/manual.md#section1_5
###
cmake_minimum_required(VERSION 3.18)

# Use the CMake setup exported by GLM
find_package(glm REQUIRED CONFIG
  NO_DEFAULT_PATH
  PATHS ${CMAKE_CURRENT_LIST_DIR}/glm/cmake/glm
)

message("-- GLM loaded")

### OUTPUT ###
set(GLM_INCLUDE_DIRS ${GLM_INCLUDE_DIRS} CACHE STRING "Include folder for the GML library.")

