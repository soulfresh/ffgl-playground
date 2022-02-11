cmake_minimum_required(VERSION 3.18)

# Add this folder to the module paths so we can configure each library
# with its own Find*.cmake file.
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

# Find the dependencies in our local Find*.cmake files.
find_package(ffgl REQUIRED)
find_package(glm REQUIRED)

set(DEPS_INCLUDE_DIRS ${FFGL_INCLUDE_DIRS} ${GLM_INCLUDE_DIRS} PARENT_SCOPE)
set(DEPS_HEADERS ${FFGL_HEADERS} ${GLM_HEADERS} PARENT_SCOPE)
set(DEPS_SOURCES ${FFGL_SOURCES} ${GLM_SOURCES} PARENT_SCOPE)
