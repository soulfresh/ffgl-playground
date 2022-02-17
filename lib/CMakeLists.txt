cmake_minimum_required(VERSION 3.18)

subdir_list(libraries ${CMAKE_CURRENT_LIST_DIR})

# Add each subdirectory in this folder as a library that
# can be used by the plugins.
foreach(lib ${libraries})
  message(STATUS "Adding ${lib} library.")

  # Get the files in this library folder.
  file(GLOB_RECURSE headers ${CMAKE_CURRENT_LIST_DIR}/${lib}/*.hpp ${CMAKE_CURRENT_LIST_DIR}/${lib}/*.h)
  file(GLOB_RECURSE sources ${CMAKE_CURRENT_LIST_DIR}/${lib}/*.cpp)

  # Add the files to the lib variables so they can be added to
  # the plugins.
  set(LIB_HEADERS ${headers} PARENT_SCOPE)
  set(LIB_SOURCES ${sources} PARENT_SCOPE)

  # Get an uppercased variable name we can use outside of this
  # file to refer to the files inside each library folder (ex. MYLIB_LIB_HEADERS).
  string(TOUPPER ${lib} l)

  # Also expose library specific versions should we need those.
  set(${l}_LIB_HEADERS ${headers} PARENT_SCOPE)
  set(${l}_LIB_SOURCES ${sources} PARENT_SCOPE)

  # TODO Compile a shared library for each.
endforeach()

set(LIB_INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR} PARENT_SCOPE)
