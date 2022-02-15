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
file(GLOB_RECURSE headers ${ffgl_include}/*.hpp ${ffgl_include}/*.h)
file(GLOB_RECURSE sources ${ffgl_include}/*.cpp)

# Remove the glsdk/glload library references since they
# will be pulled in automatically by FFGLSDK.
list(FILTER headers EXCLUDE REGEX "glsdk")
list(FILTER sources EXCLUDE REGEX "glsdk")
# Remove FFGLSDK.cpp because it will cause duplicate
# definition errors during linking.
list(FILTER sources EXCLUDE REGEX "FFGLSDK.cpp")

message("-- FFGL loaded")

# Build an object library that allows the object files
# to be re-used between builds.
# See https://cmake.org/cmake/help/latest/command/add_library.html?highlight=add_library#id3
add_library(FFGL OBJECT ${sources})
# Can't figure out how to do this with a static library.
# Resolume fails to find the plugMain function.
# add_library(FFGL STATIC ${sources})
# target_include_directories(FFGL PUBLIC ${headers})

# Link in dependencies
find_library(OPENGL OpenGL REQUIRED)
target_link_libraries(FFGL ${OPENGL})
target_compile_options(FFGL PUBLIC ${GLOBAL_COMPILER_FLAGS})

### OUTPUT ###
# Using CACHE variables so they are exposed all the way to the top level CMakeLists
# set(FFGL_INCLUDE_DIRS ${ffgl_include} CACHE STRING "Include folder for the FFGL SDK.")
# set(FFGL_HEADERS ${headers} CACHE STRING "All header files in the FFGL SDK.")
# set(FFGL_SOURCES ${sources} CACHE STRING "All source files in the FFGL SDK.")
set(FFGL_INCLUDE_DIRS ${ffgl_include})
set(FFGL_HEADERS ${headers})
set(FFGL_SOURCES ${sources})
