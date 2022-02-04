# TODO Do we need this in every cmake file?
cmake_minimum_required(VERSION 3.18)

# --- FFGL ---
find_path(ffgl_include FFGLSDK.h REQUIRED
  HINTS ${DEPS_DIR}/ffgl
  PATH_SUFFIXES source/lib
)

set(FFGL_INCLUDE_DIR ${ffgl_include} PARENT_SCOPE)

file(GLOB_RECURSE ffgl_headers ${ffgl_include}/*.hpp ${ffgl_include}/*.h)
file(GLOB_RECURSE ffgl_sources ${ffgl_include}/*.cpp)

# Remove the glsdk/glload library. Not sure why it's included in
# the FFGL SDK.
list(FILTER ffgl_headers EXCLUDE REGEX "glsdk")
list(FILTER ffgl_sources EXCLUDE REGEX "glsdk")

add_library(ffgl STATIC ${ffgl_sources})
target_include_directories(ffgl PUBLIC ${ffgl_include})


# --- GLM ---
find_path(glm_include
  NAMES glm.h glm.hpp
  HINTS ${DEPS_DIR}/glm/glm
  REQUIRED
  NO_DEFAULT_PATH
)

message("-- GLM Found: ${glm_include}")

set(GLM_INCLUDE_DIR ${glm_include} PARENT_SCOPE)

# file(GLOB_RECURSE glm_headers ${ffgl_include}/*.hpp ${ffgl_include}/*.h)

# target_include_directories(lolpxl PUBLIC ${glm_include})
# add_library(glm STATIC ${glm_headers})
# target_include_directories(glm PUBLIC ${glm_include})
# set_target_properties(glm PROPERTIES LINKER_LANGUAGE CXX)

