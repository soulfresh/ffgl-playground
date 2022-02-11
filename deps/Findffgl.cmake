###
# EXPORTS
# -------
# FFGL_INCLUDE_DIRS
# FFGL_HEADERS
# FFGL_SOURCES
###
cmake_minimum_required(VERSION 3.18)

# Find the path to the FFGL include dir
find_path(ffgl_include FFGLSDK.h REQUIRED
  HINTS ${DEPS_DIR}/ffgl
  PATH_SUFFIXES source/lib
)

# Get all of the FFGL SDK files
file(GLOB_RECURSE ffgl_headers ${ffgl_include}/*.hpp ${ffgl_include}/*.h)
file(GLOB_RECURSE ffgl_sources ${ffgl_include}/*.cpp)

# Remove the glsdk/glload library. Not sure why it's included in
# the FFGL SDK.
list(FILTER ffgl_headers EXCLUDE REGEX "glsdk")
list(FILTER ffgl_sources EXCLUDE REGEX "glsdk")
list(FILTER ffgl_sources EXCLUDE REGEX "FFGLSDK.cpp")

message("-- FFGL loaded")

# Build an object library that allows the object files
# to be re-used between builds.
# See https://cmake.org/cmake/help/latest/command/add_library.html?highlight=add_library#id3
add_library(FFGL OBJECT ${ffgl_sources})
# Can't figure out how to do this with a static library.
# Resolume fails to find the plugMain function.
# add_library(FFGL STATIC ${ffgl_sources})
# target_include_directories(FFGL PUBLIC ${ffgl_headers})

# TODO Precompile headers?
# Link in dependencies
find_library(OPENGL OpenGL REQUIRED)
target_link_libraries(FFGL ${OPENGL})

### OUTPUT ###
# Using CACHE variables so they are exposed all the way to the top level CMakeLists
set(FFGL_INCLUDE_DIRS ${ffgl_include} CACHE STRING "Include folder for the FFGL SDK.")
set(FFGL_HEADERS ${ffgl_headers} CACHE STRING "All header files in the FFGL SDK.")
set(FFGL_SOURCES ${ffgl_sources} CACHE STRING "All source files in the FFGL SDK.")

