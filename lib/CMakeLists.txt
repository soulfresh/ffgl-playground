cmake_minimum_required(VERSION 3.18)

subdir_list(libraries ${CMAKE_CURRENT_LIST_DIR})

set(all_headers "")
set(all_sources "")
set(all_libs "")

# Add each subdirectory in this folder as a library that
# can be used by the plugins.
foreach(lib ${libraries})
  message(STATUS "Adding ${lib} library.")

  # Get the files in this library folder.
  file(GLOB_RECURSE sources ${CMAKE_CURRENT_LIST_DIR}/${lib}/*.cpp)
  file(GLOB_RECURSE headers ${CMAKE_CURRENT_LIST_DIR}/${lib}/*.hpp ${CMAKE_CURRENT_LIST_DIR}/${lib}/*.h)
  # Treat any file with a .pch extension as precompiled header list.
  file(GLOB_RECURSE pchs ${CMAKE_CURRENT_LIST_DIR}/${lib}/*.pch)

  # Add the files to the lib variables so they can be added to
  # the plugins.
  list(APPEND all_headers ${headers})
  list(APPEND all_sources ${sources})

  # Get an uppercased variable name we can use outside of this
  # file to refer to the files inside each library folder (ex. MYLIB_LIB_HEADERS).
  string(TOUPPER ${lib} l)

  # Also expose library specific versions should we need those.
  set(${l}_LIB_HEADERS ${headers} PARENT_SCOPE)
  set(${l}_LIB_SOURCES ${sources} PARENT_SCOPE)

  # If this lib folder has sources, compile a shared library from them.
  if(sources)
    message(STATUS "Creating Shared Library: ${lib}")

    add_library(${lib} STATIC
      ${sources}
      $<TARGET_OBJECTS:FFGL>
    )

    target_include_directories(${lib} PUBLIC
      ${CMAKE_CURRENT_LIST_DIR}
      ${DEPS_INCLUDE_DIRS}
    )

    # TODO Build any .pch files as precompiled libraries
    # Precompile headers if there are any .pch files
    if(pchs)
      target_precompile_headers(${lib} PRIVATE ${pchs})
    endif()

    target_link_libraries(${lib}
      ${OPENGL}
    )

    list(APPEND all_libs ${lib})
  endif()
endforeach()

set(LIBS ${all_libs} PARENT_SCOPE)
set(LIB_HEADERS ${all_headers} PARENT_SCOPE)
set(LIB_SOURCES ${all_sources} PARENT_SCOPE)
set(LIB_INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR} PARENT_SCOPE)

