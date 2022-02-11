cmake_minimum_required(VERSION 3.18)

###
# Get a list of all subdirectories of a directory
# @param result - The variable to set
# @param curdir - The directory to look in
#
# Example:
# SubDirList(projects ${CMAKE_CURRENT_LIST_DIR})
###
macro(SubDirList result curdir)
  file(GLOB children RELATIVE ${curdir} ${curdir}/*)
  set(dirlist "")
  foreach(child ${children})
    if(IS_DIRECTORY ${curdir}/${child})
      LIST(APPEND dirlist ${child})
    endif()
  endforeach()
  set(${result} ${dirlist})
endmacro()

###
# Add a new plugin to the build. The name of the folder and
# the output plugin name will be the same. Every plugin is
# built the same way.
#
# Example:
# AddPlugin(MyPluginName)
###
macro(AddPlugin name)
  # sources for this plugin
  file(GLOB_RECURSE headers ${CMAKE_CURRENT_LIST_DIR}/${name}/*.hpp ${CMAKE_CURRENT_LIST_DIR}/${name}/*.h)
  file(GLOB_RECURSE sources ${CMAKE_CURRENT_LIST_DIR}/${name}/*.cpp)

  # Build the plugin as a module library.
  add_library(${name} MODULE
    ${sources}
    # Include FFGL as pre-compiled objects.
    # Not sure why I can't get a static lib to work instead.
    $<TARGET_OBJECTS:FFGL>
  )

  # Precompile all headers in deps and libs
  target_precompile_headers(${name} PUBLIC ${DEPS_HEADERS} ${LIB_HEADERS})

  # Output a bundle file.
  set_target_properties(${name} PROPERTIES BUNDLE TRUE)
  target_include_directories(${name} PUBLIC
    # ${DEPS_INCLUDE_DIRS}
    ${FFGL_INCLUDE_DIRS}
    ${GLM_INCLUDE_DIRS}
    ${LIB_INCLUDE_DIRS}
  )

  # Plugin dependencies
  target_link_libraries(${name}
    ${OPENGL}
  )

  # Install the generated plugin to the local plugins directory
  install(TARGETS ${name} DESTINATION ${PLUGIN_OUTPUT_DIRECTORY})
endmacro()

###
# Add all folders in the current directory to the cmake build
# as plugins using the folder name as the plugin name.
#
# Example:
# AddAllPlugins()
###
macro(AddAllPlugins)
  SubDirList(projects ${CMAKE_CURRENT_LIST_DIR})

  foreach(subdir ${projects})
    message(STATUS "Found Plugin: ${subdir}")
    AddPlugin(${subdir})
  endforeach()
endmacro()
